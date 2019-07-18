//
//  NetworkImage.swift
//  wallabag
//
//  Created by Marinel Maxime on 17/07/2019.
//

import SwiftUI

public struct NetworkImage: SwiftUI.View {
    @State private var image: UIImage? = nil

    public let imageURL: URL?
    public let placeholderImage: UIImage
    public let animation: Animation = .basic()

    public var body: some SwiftUI.View {
        Image(uiImage: image ?? placeholderImage)
            .resizable()
            .onAppear(perform: loadImage)
            .transition(.opacity)
            .id(image ?? placeholderImage)
    }

    private func loadImage() {
        guard let imageURL = imageURL, image == nil else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if nil == error {
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
}

#if DEBUG
    struct NetworkImage_Previews: PreviewProvider {
        static var previews: some SwiftUI.View {
            NetworkImage(imageURL: URL(string: "https://www.apple.com/favicon.ico")!,
                         placeholderImage: UIImage(systemName: "bookmark")!)
        }
    }
#endif
