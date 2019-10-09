//
//  StubView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct StubView: View {
    var body: some View {
        Text("test")
    }
}

#if DEBUG
struct StubView_Previews: PreviewProvider {
    static var previews: some View {
        StubView().previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
