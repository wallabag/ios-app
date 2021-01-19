import Foundation
import SwiftUI

struct RouterView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        router.route.view
    }
}
