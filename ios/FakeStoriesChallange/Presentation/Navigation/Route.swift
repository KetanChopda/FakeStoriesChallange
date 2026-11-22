//
//  Route.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

/// Every destination the app can push; screens link by value, never by view type.
enum Route: Hashable {
    case product(id: Int)
    case category(name: String)
    case enquiry(productID: Int)
}
