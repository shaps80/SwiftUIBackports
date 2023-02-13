#if os(iOS)
import SwiftUI

/*
 WIP
 */

@available(iOS, deprecated: 16)
private extension Backport where Wrapped: View {
    func scrollContentBackground(_ visibility: Backport<Any>.Visibility) -> some View {
        wrapped.inspect { inspector in
            inspector.sibling(ofType: PlatformScrollView.self)
        } customize: { view in
            let isHidden = visibility == .hidden
            print(isHidden)
        }
    }
}
#endif
