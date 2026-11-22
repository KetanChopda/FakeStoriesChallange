//
//  RemoteImage.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Loads a product image with cache-first behavior on iOS 27+; earlier systems use standard HTTP caching.
struct RemoteImage: View {
    let url: URL?

    var body: some View {
        if let url {
            if #available(iOS 27, *) {
                AsyncImage(request: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
        } else {
            Rectangle().fill(.quaternary)
        }
    }
}

extension View {
    /// Routes image loads in this subtree through the app's image session on iOS 27+.
    @ViewBuilder
    func imageSession(_ session: URLSession) -> some View {
        if #available(iOS 27, *) {
            asyncImageURLSession(session)
        } else {
            self
        }
    }
}
