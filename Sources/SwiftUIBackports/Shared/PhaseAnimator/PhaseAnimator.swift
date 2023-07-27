//import SwiftUI
//import SwiftBackports
//
//@available(iOS, deprecated: 17)
//@available(tvOS, deprecated: 17)
//@available(watchOS, deprecated: 10)
//@available(macOS, deprecated: 14)
//extension Backport<Any> {
//    /// A container that animates its content by automatically cycling through
//    /// a collection of phases that you provide, each defining a discrete step
//    /// within an animation.
//    struct PhaseAnimator<Phase, Content>: View where Phase: Equatable, Content: View {
//        /// Cycles through the given phases when the trigger value changes,
//        /// updating the view builder closure that you supply.
//        ///
//        /// The phases that you provide specify the individual values that will
//        /// be animated to when the trigger value changes.
//        ///
//        /// When the view first appears, the value from the first phase is provided
//        /// to the `content` closure. When the trigger value changes, the content
//        /// closure is called with the value from the second phase and its
//        /// corresponding animation. This continues until the last phase is
//        /// reached, after which the first phase is animated to.
//        ///
//        /// - Parameters:
//        ///   - phases: Phases defining the states that will be cycled through.
//        ///     This sequence must not be empty. If an empty sequence is provided,
//        ///     a visual warning will be displayed in place of this view, and a
//        ///     warning will be logged.
//        ///   - trigger: A value to observe for changes.
//        ///   - content: A view builder closure.
//        ///   - animation: A closure that returns the animation to use when
//        ///     transitioning to the next phase. If `nil` is returned, the
//        ///     transition will not be animated.
//        public init(_ phases: some Sequence<Phase>, trigger: some Equatable, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) {
//            let phases = phases.map { $0 }
//            self.phases = phases
//            self.trigger = Trigger(trigger)
//            self.content = content
//            self.animation = animation
//            precondition(!phases.isEmpty, "PhaseAnimator requires at least one phase value")
//            _phase = .init(initialValue: phases.first!)
//        }
//
//        /// Cycles through the given phases continuously, updating the content
//        /// using the view builder closure that you supply.
//        ///
//        /// The phases that you provide define the individual values that will
//        /// be animated between.
//        ///
//        /// When the view first appears, the the first phase is provided
//        /// to the `content` closure. The animator then immediately animates
//        /// to the second phase, using an animation returned from the `animation`
//        /// closure. This continues until the last phase is reached, after which
//        /// the animator loops back to the beginning.
//        ///
//        /// - Parameters:
//        ///   - phases: Phases defining the states that will be cycled through.
//        ///     This sequence must not be empty. If an empty sequence is provided,
//        ///     a visual warning will be displayed in place of this view, and a
//        ///     warning will be logged.
//        ///   - content: A view builder closure.
//        ///   - animation: A closure that returns the animation to use when
//        ///     transitioning to the next phase. If `nil` is returned, the
//        ///     transition will not be animated.
//        public init(_ phases: some Sequence<Phase>, @ViewBuilder content: @escaping (Phase) -> Content, animation: @escaping (Phase) -> Animation? = { _ in .default }) {
//            let phases = phases.map { $0 }
//            self.phases = phases
//            self.trigger = Trigger()
//            self.content = content
//            self.animation = animation
//            precondition(!phases.isEmpty, "PhaseAnimator requires at least one phase value")
//            _phase = .init(initialValue: phases.first!)
//        }
//
//        @State private var phase: Phase
//        @State private var animate: Bool = false
//
//        private let phases: [Phase]
//        private let trigger: Trigger
//        private let content: (Phase) -> Content
//        private let animation: (Phase) -> Animation?
//
//        public var body: some View {
//            content(phase)
//                .animation(animation(phase)?.repeatCount(trigger.repeatForever ? .max : 0), value: phase)
//                .backport.onChange(of: animate) { _ in
//                    print("before: \(self.phase), after: \(next ?? phase)")
//                    phase = next ?? phase
//                }
//                .backport.onChange(of: trigger) { _ in
//                    animate.toggle()
//                }
//                .onAppear {
//                    if !trigger.repeatForever {
//                        animate.toggle()
//                    }
//                }
//        }
//
//        private var next: Phase? {
//            guard let index = phases.firstIndex(of: phase) else { return nil }
//            let next = phases.index(after: index)
//            guard phases.indices.contains(next) else {
//                return trigger.repeatForever ? phases.first! : nil
//            }
//            return phases[next]
//        }
//    }
//}
//
//public extension Backport where Wrapped: View {
//    /// Cycles through the given phases when the trigger value changes,
//    /// updating the view using the modifiers you apply in `body`.
//    ///
//    /// The phases that you provide specify the individual values that will
//    /// be animated to when the trigger value changes.
//    ///
//    /// When the view first appears, the value from the first phase is provided
//    /// to the `content` closure. When the trigger value changes, the content
//    /// closure is called with the value from the second phase and its
//    /// corresponding animation. This continues until the last phase is
//    /// reached, after which the first phase is animated to.
//    ///
//    /// - Parameters:
//    ///   - phases: Phases defining the states that will be cycled through.
//    ///     This sequence must not be empty. If an empty sequence is provided,
//    ///     a visual warning will be displayed in place of this view, and a
//    ///     warning will be logged.
//    ///   - trigger: A value to observe for changes.
//    ///   - content: A view builder closure that takes two parameters. The first
//    ///     parameter is a proxy value representing the modified view. The
//    ///     second parameter is the current phase.
//    ///   - animation: A closure that returns the animation to use when
//    ///     transitioning to the next phase. If `nil` is returned, the
//    ///     transition will not be animated.
//    func phaseAnimator<Phase>(_ phases: some Sequence<Phase>, trigger: some Equatable, @ViewBuilder content: @escaping (Backport<Any>.PlaceholderContentView<Self>, Phase) -> some View, animation: @escaping (Phase) -> Animation? = { _ in .default }) -> some View where Phase: Equatable {
//        Backport<Any>.PhaseAnimator(phases, trigger: trigger) { phase in
//            Backport<Any>.PlaceholderContentView(wrapped)
//        } animation: { phase in
//            animation(phase)
//        }
//    }
//
//    /// Cycles through the given phases continuously, updating the content
//    /// using the view builder closure that you supply.
//    ///
//    /// The phases that you provide define the individual values that will
//    /// be animated between.
//    ///
//    /// When the view first appears, the the first phase is provided
//    /// to the `content` closure. The animator then immediately animates
//    /// to the second phase, using an animation returned from the `animation`
//    /// closure. This continues until the last phase is reached, after which
//    /// the animator loops back to the beginning.
//    ///
//    /// - Parameters:
//    ///   - phases: Phases defining the states that will be cycled through.
//    ///     This sequence must not be empty. If an empty sequence is provided,
//    ///     a visual warning will be displayed in place of this view, and a
//    ///     warning will be logged.
//    ///   - content: A view builder closure that takes two parameters. The first
//    ///     parameter is a proxy value representing the modified view. The
//    ///     second parameter is the current phase.
//    ///   - animation: A closure that returns the animation to use when
//    ///     transitioning to the next phase. If `nil` is returned, the
//    ///     transition will not be animated.
//    func phaseAnimator<Phase>(_ phases: some Sequence<Phase>, @ViewBuilder content: @escaping (Backport<Any>.PlaceholderContentView<Self>, Phase) -> some View, animation: @escaping (Phase) -> Animation? = { _ in .default }) -> some View where Phase: Equatable {
//        Backport<Any>.PhaseAnimator(phases, trigger: Trigger()) { phase in
//            Backport<Any>.PlaceholderContentView(wrapped)
//        } animation: { phase in
//            animation(phase)
//        }
//    }
//}
//
//extension Backport<Any> {
//    /// A placeholder used to construct an inline modifier, transition, or other
//    /// helper type.
//    ///
//    /// You don't use this type directly. Instead SwiftUI creates this type on
//    /// your behalf.
//    public struct PlaceholderContentView<Value>: View {
//        let content: any View
//        init(_ content: Value) where Value: View {
//            self.content = content
//        }
//    }
//}
//
//public extension Backport.PlaceholderContentView {
//    var body: some View {
//        AnyView(content)
//    }
//}
//
//struct Trigger {
//    let base: Any
//    let repeatForever: Bool
//    private let comparator: (Any) -> Bool
//
//    init() {
//        self.base = false
//        self.comparator = { _ in true }
//        self.repeatForever = true
//    }
//
//    init<E>(_ base: E) where E: Equatable {
//        self.base = base
//        self.comparator = { $0 as! E == base }
//        self.repeatForever = false
//    }
//}
//
//extension Trigger: Equatable {
//    static func == (lhs: Trigger, rhs: Trigger) -> Bool {
//        return lhs.comparator(rhs.base) && rhs.comparator(lhs.base)
//    }
//}
//
////private struct InfiniteIterator<Base: Collection>: IteratorProtocol {
////
////    private let collection: Base
////    private var index: Base.Index
////
////    /// Creates a new iterator for the specified base collection
////    ///
////    /// - Parameter collection: The base collection to iterate over
////    init(collection: Base, startingAt index: Base.Index? = nil) {
////        self.collection = collection
////
////        if let index = index, collection.indices.contains(index) {
////            self.index = index
////        } else {
////            self.index = collection.startIndex
////        }
////    }
////
////    /// Returns the next element. If the endIndex has been reached, this will returns the first element again.
////    ///
////    /// - Returns: Returns the next element. If the collection is empty, this returns nil
////    mutating func next() -> Base.Iterator.Element? {
////        guard !collection.isEmpty else { return nil }
////
////        let result = collection[index]
////        collection.formIndex(after: &index)
////
////        if index == collection.endIndex {
////            index = collection.startIndex
////        }
////
////        return result
////    }
////
////}
