//
//  TipView.swift
//  wallabag
//
//  Created by Marinel Maxime on 12/02/2020.
//

import SwiftUI

struct TipView: View {
    @ObservedObject var skPublisher = SKPublisher()

    var body: some View {
        VStack {
            Spacer()
            Text("This application is developed on free time")
            Text("It is free and will remain so.")
            Text("But you can contribute financially by making a donation whenever you want to support the project.")
            if skPublisher.canMakePayments {
                Button(
                    action: { self.skPublisher.purchaseTip() },
                    label: {
                        self.skPublisher.tipProduct.map { product in
                            Text(product.title)
                        }
                    }
                ).padding()
            } else {
                Text("It seems impossible to make a payment")
            }
            Spacer()
        }
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        TipView()
    }
}
