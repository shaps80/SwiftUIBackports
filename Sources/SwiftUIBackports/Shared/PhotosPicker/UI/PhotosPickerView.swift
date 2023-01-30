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
                    Text("Done")
                }

                Backport.ToolbarItem(placement: .cancellationAction) {
                    Text("Cancel")
                }

                Backport.ToolbarItem(placement: .principal) {
                    Text("Principal")
                }
            }
//            .backport.toolbar {
//                picker
//            } leading: {
//                Button("Cancel") {
//                    dismiss()
//                }
//            } trailing: {
//                Button("Add") {
//
//                }
//                .font(.body.weight(.semibold))
//                .disabled(selection.isEmpty)
//                .opacity(maxSelection == 1 ? 0 : 1)
//            }
//            .controller { controller in
//                if #available(iOS 14, *) { } else {
//                    guard controller?.navigationItem.titleView == nil else { return }
//                    controller?.navigationItem.titleView = UIHostingController(rootView: picker, ignoreSafeArea: false).view
//                }
//            }
        }
        .backport.interactiveDismissDisabled()
    }

    private var picker: some View {
        Picker("", selection: $source) {
            ForEach(Source.allCases) { source in
                Text(source.rawValue)
                    .tag(source)
            }
        }
        .pickerStyle(.segmented)
        .fixedSize()
    }
}

//private extension Backport where Wrapped: View {
//    @ViewBuilder
//    func toolbar<Leading: View, Trailing: View, Principal: View>(@ViewBuilder principal: () -> Principal, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) -> some View {
//        if #available(iOS 14, *) {
//            content.toolbar {
////                ToolbarItem(placement: .navigationBarLeading, content: leading)
////                ToolbarItem(placement: .navigationBarTrailing, content: trailing)
////                ToolbarItem(placement: .principal, content: principal)
//            }
//        } else {
//            content
//                .navigationBarItems(leading: leading(), trailing: trailing())
//        }
//    }
//}
#endif
