//
//  FakeStoreFixtures.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// Sample Fake Store responses, shaped like the real API.
enum FakeStoreFixtures {
    static let singleProductJSON = """
    {"id":3,"title":"Backpack","price":109.95,"description":"Fits a 15-inch laptop",
     "category":"men's clothing","image":"https://fakestoreapi.com/img/3.jpg",
     "rating":{"rate":3.9,"count":120}}
    """

    static let productsJSON = """
    [\(singleProductJSON),
     {"id":4,"title":"Jacket","price":22.3,"description":"Warm and light",
      "category":"women's clothing","image":"https://fakestoreapi.com/img/4.jpg",
      "rating":{"rate":4.1,"count":259}}]
    """

    static let malformedJSON = "[{\"id\": 3, \"title\": "
}
