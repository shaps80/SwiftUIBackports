import SwiftUI

#if os(iOS)
@available(iOS 14.0, *)
protocol FontProvider {
    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor
}

@available(iOS 14.0, *)
extension FontProvider {
    func font(with traitCollection: UITraitCollection?) -> UIFont {
        return UIFont(descriptor: fontDescriptor(with: traitCollection), size: 0)
    }
}

@available(iOS 14.0, *)
protocol FontModifier {
    func modify(_ fontDescriptor: inout UIFontDescriptor)
}

@available(iOS 14.0, *)
protocol StaticFontModifier: FontModifier {
    init()
}

@available(iOS 14.0, *)
struct TextStyleProvider: FontProvider {
    var style: UIFont.TextStyle
    var design: UIFontDescriptor.SystemDesign?

    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor {
        UIFont
            .preferredFont(forTextStyle: style, compatibleWith: traitCollection)
            .fontDescriptor
            .withDesign(design ?? .default)!
    }
}

@available(iOS 14.0, *)
struct SystemProvider: FontProvider {
    var size: CGFloat
    var design: UIFontDescriptor.SystemDesign
    var weight: UIFont.Weight?

    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor {
        UIFont.systemFont(ofSize: size)
            .fontDescriptor
            .addingAttributes([
                .traits: [
                    UIFontDescriptor.TraitKey.weight: (weight ?? .regular).rawValue
                ]
            ])
            .withDesign(design)!
    }
}

@available(iOS 14.0, *)
struct NamedProvider: FontProvider {
    var name: String
    var size: CGFloat
    var textStyle: UIFont.TextStyle?

    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor {
        if let textStyle = textStyle {
            let metrics = UIFontMetrics(forTextStyle: textStyle )

            return UIFontDescriptor(fontAttributes: [
                .family: name,
                .size: metrics.scaledValue(for: size, compatibleWith: traitCollection)
            ])
        } else {
            return UIFontDescriptor(fontAttributes: [
                .family: name,
                .size: size
            ])
        }
    }
}

@available(iOS 14.0, *)
struct StaticModifierProvider<M: StaticFontModifier>: FontProvider {
    var base: FontProvider

    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor {
        var descriptor = base.fontDescriptor(with: traitCollection)
        M().modify(&descriptor)
        return descriptor
    }
}

@available(iOS 14.0, *)
struct ModifierProvider<M: FontModifier>: FontProvider {
    var base: FontProvider
    var modifier: M

    func fontDescriptor(with traitCollection: UITraitCollection?) -> UIFontDescriptor {
        var descriptor = base.fontDescriptor(with: traitCollection)
        modifier.modify(&descriptor)
        return descriptor
    }
}

@available(iOS 14.0, *)
struct ItalicModifier: StaticFontModifier {
    init() { }

    func modify(_ fontDescriptor: inout UIFontDescriptor) {
        var traits = fontDescriptor.symbolicTraits
        traits.insert(.traitItalic)
        fontDescriptor = fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.symbolic: traits.rawValue
            ]
        ])
    }
}

@available(iOS 14.0, *)
struct BoldModifier: StaticFontModifier {
    init() { }

    func modify(_ fontDescriptor: inout UIFontDescriptor) {
        var traits = fontDescriptor.symbolicTraits
        traits.insert(.traitBold)
        fontDescriptor = fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.symbolic: traits.rawValue,
                UIFontDescriptor.TraitKey.weight: nil
            ]
        ])
    }
}

@available(iOS 14.0, *)
struct WeightModifier: FontModifier {
    var weight: UIFont.Weight?

    func modify(_ fontDescriptor: inout UIFontDescriptor) {
        fontDescriptor = fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: (weight ?? .regular).rawValue
            ]
        ])
    }
}

@available(iOS 14.0, *)
struct LeadingModifier: FontModifier {
    var leading: Font.Leading?

    func modify(_ fontDescriptor: inout UIFontDescriptor) {
        var traits = fontDescriptor.symbolicTraits
        switch leading {
        case .loose:
            traits.insert(.traitLooseLeading)
            traits.remove(.traitTightLeading)
        case .tight:
            traits.remove(.traitLooseLeading)
            traits.insert(.traitTightLeading)
        default:
            traits.remove(.traitLooseLeading)
            traits.remove(.traitTightLeading)
        }

        fontDescriptor = fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.symbolic: traits.rawValue
            ]
        ])
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@available(iOS 14.0, *)
func resolveFont(_ font: Font) -> FontProvider? {
    let mirror = Mirror(reflecting: font)

    guard let provider = mirror.descendant("provider", "base") else {
        return nil
    }

    return resolveFontProvider(provider)
}

@available(iOS 14.0, *)
func resolveFontProvider(_ provider: Any) -> FontProvider? {
    let mirror = Mirror(reflecting: provider)

    switch String(describing: type(of: provider)) {
    case String(describing: TextStyleProvider.self):
        guard let style = mirror.descendant("style") as? Font.TextStyle else {
            return nil
        }

        let design = mirror.descendant("design") as? Font.Design
        return TextStyleProvider(style: style.uiTextStyle, design: design?.uiSystemDesign)
    case String(describing: StaticModifierProvider<ItalicModifier>.self):
        guard let base = mirror.descendant("base", "provider", "base") else {
            return nil
        }

        return resolveFontProvider(base).map(StaticModifierProvider<ItalicModifier>.init)
    case String(describing: StaticModifierProvider<BoldModifier>.self):
        guard let base = mirror.descendant("base", "provider", "base") else {
            return nil
        }

        return resolveFontProvider(base).map(StaticModifierProvider<BoldModifier>.init)
    case String(describing: ModifierProvider<WeightModifier>.self):
        guard let base = mirror.descendant("base", "provider", "base") else {
            return nil
        }

        let weight = mirror.descendant("modifier", "weight") as? Font.Weight
        let modifier = WeightModifier(weight: weight?.uiFontWeight)
        return resolveFontProvider(base).map { ModifierProvider(base: $0, modifier: modifier) }
    case String(describing: ModifierProvider<LeadingModifier>.self):
        guard let base = mirror.descendant("base", "provider", "base") else {
            return nil
        }

        let leading = mirror.descendant("modifier", "leading") as? Font.Leading
        let modifier = LeadingModifier(leading: leading)
        return resolveFontProvider(base).map { ModifierProvider(base: $0, modifier: modifier) }
    case String(describing: SystemProvider.self):
        guard let size = mirror.descendant("size") as? CGFloat,
              let design = mirror.descendant("design") as? Font.Design else {
            return nil
        }

        let weight = mirror.descendant("weight") as? Font.Weight

        return SystemProvider(size: size, design: design.uiSystemDesign, weight: weight?.uiFontWeight)
    case String(describing: NamedProvider.self):
        guard let name = mirror.descendant("name") as? String,
              let size = mirror.descendant("size") as? CGFloat else {
            return nil
        }

        let textStyle = mirror.descendant("textStyle") as? Font.TextStyle

        return NamedProvider(name: name, size: size, textStyle: textStyle?.uiTextStyle)
    default:
        // Not exhaustive, more providers need to be handled here.
        return nil
    }
}

extension Font.Weight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .light: return .light
        case .thin: return .thin
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }
}

extension Font.Design {
    var uiSystemDesign: UIFontDescriptor.SystemDesign {
        switch self {
        case .monospaced: return .monospaced
        case .rounded: return .rounded
        case .serif: return .serif
        default:  return .`default`
        }
    }
}

extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .caption: return .caption1
        case .caption2: return .caption2
        case .footnote: return .footnote
        case .callout: return .callout
        case .subheadline: return .subheadline
        case .headline: return .headline
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .largeTitle: return .largeTitle
        default: return .body
        }
    }
}

extension LegibilityWeight {
    var uiLegibilityWeight: UILegibilityWeight {
        switch self {
        case .bold: return .bold
        default: return .regular
        }
    }
}
#endif
