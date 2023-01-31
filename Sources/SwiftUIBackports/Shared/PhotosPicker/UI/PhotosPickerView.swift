#if os(iOS)
import SwiftUI
import PhotosUI

internal struct PhotosPickerView: View {
    @Environment(\.backportDismiss) private var dismiss
    @Binding var selection: [Backport<Any>.PhotosPickerItem]

    let filter: Backport<Any>.PHPickerFilter?
    let maxSelection: Int?
    let selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior
    let encoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy
    let library: PHPhotoLibrary

    private enum Source: String, CaseIterable, Identifiable {
        var id: Self { self }
        case photos = "Photos"
        case albums = "Albums"
    }

    @State private var source: Source = .photos

    var body: some View {
        NavigationView {
            List {

            }
            .navigationBarTitle(Text("Photos"), displayMode: .inline)
            .backport.toolbar {
                Backport.ToolbarItem(placement: .primaryAction) {
                    Button("Add") {

                    }
                    .font(.body.weight(.semibold))
                    .disabled(selection.isEmpty)
                    .opacity(maxSelection == 1 ? 0 : 1)
                }

                Backport.ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        selection = []
                        dismiss()
                    }
                }

                Backport.ToolbarItem(placement: .principal) {
                    Picker("", selection: $source) {
                        ForEach(Source.allCases) { source in
                            Text(source.rawValue)
                                .tag(source)
                        }
                    }
                    .pickerStyle(.segmented)
                    .fixedSize()
                }

                Backport.ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Text(selection.isEmpty ? "Select Items" : "Selected (\(selection.count))")
                            .font(.subheadline.weight(.semibold))

                        Text("Select up to \(maxSelection ?? 1) items.")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
        }
        .backport.interactiveDismissDisabled()
        .backport.onChange(of: source) { newValue in
            selection = source == .albums ? [.init(itemIdentifier: "")] : []
        }
    }
}
#endif
