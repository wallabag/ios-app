//
//  BetaDisclaimerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 07/11/2019.
//

import SwiftUI

struct BetaDisclaimerView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Wallabag").font(.largeTitle).bold()
            Spacer()
            Text("Thank you for choosing to participate in this beta.").multilineTextAlignment(.center)
            Text("""
            Before continuing it is important to make a backup of your wallabag instance.
            For this you need to connect to your instance and use the export menu.
            """).multilineTextAlignment(.center)

            Text("Thank you for sending your feedback on the github.").multilineTextAlignment(.center)

            Text("Happy reading")
            Spacer()
            Button(action: {
                WallabagUserDefaults.showBetaDisclamer = false
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Configure App") })
        }
    }
}

struct BetaDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        BetaDisclaimerView()
    }
}
