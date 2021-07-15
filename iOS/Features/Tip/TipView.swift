import SwiftUI

struct TipView: View {
    @ObservedObject var tipViewModel = TipViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("This application is developed on free time")
            Text("It is free and will remain so.")
            Text("But you can contribute financially by making a donation whenever you want to support the project.")
            Spacer()
            HStack {
                Spacer()
                if tipViewModel.canMakePayments {
                    if self.tipViewModel.tipProduct != nil {
                        Button(
                            action: { self.tipViewModel.purchaseTip() },
                            label: {
                                self.tipViewModel.tipProduct.map { product in
                                    Text(product.title)
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
        }.padding()
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        TipView()
    }
}
