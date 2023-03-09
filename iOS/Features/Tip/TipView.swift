import SwiftUI

struct TipView: View {
    @StateObject var tipViewModel = TipViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("This application is developed on free time")
            Text("It is free and will remain so.")
            Text("But you can contribute financially by making a donation whenever you want to support the project.")
            Spacer()
            if tipViewModel.paymentSuccess {
                HStack {
                    Spacer()
                    Text("Thank you for your Tip!")
                        .font(.title)
                    Spacer()
                }
            }
            Spacer()
            HStack {
                Spacer()
                if tipViewModel.canMakePayments {
                    if self.tipViewModel.tipProduct != nil {
                        Button(
                            action: { Task { await purchase() } },
                            label: {
                                self.tipViewModel.tipProduct.map { product in
                                    HStack {
                                        Text(product.displayName)
                                        Text(product.displayPrice)
                                    }
                                }
                            }
                        )
                    } else {
                        Text("Loading...")
                    }
                } else {
                    Text("It seems impossible to make a payment.")
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Don")
    }

    @MainActor
    func purchase() async {
        _ = try? await tipViewModel.purchaseTip()
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        TipView()
    }
}
