import SwiftUI

struct ErrorView: View {
    @Environment(ErrorViewModel.self) var errorViewModel: ErrorViewModel
    var body: some View {
        errorViewModel.lastError.map {
            Text($0.localizedDescription)
                .foregroundColor(.red)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
