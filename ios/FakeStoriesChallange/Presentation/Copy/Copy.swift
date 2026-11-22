//
//  Copy.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Foundation

/// User-facing text, kept in one place so it can be localized.
enum Copy {
    static let homeTitle = LocalizedStringResource("Catalogue")
    static let featuredTitle = LocalizedStringResource("Top rated")
    static let categoriesTitle = LocalizedStringResource("Categories")
    static let moreInCategoryTitle = LocalizedStringResource("More in this category")
    static let loadFailed = LocalizedStringResource("Something went wrong.")
    static let offlineMessage = LocalizedStringResource("You're offline. Check your connection and try again.")
    static let serverMessage = LocalizedStringResource("The catalogue is unavailable right now. Please try again shortly.")
    static let enquiryOfflineMessage = LocalizedStringResource("You're offline. Your enquiry wasn't sent.")
    static let enquiryServerMessage = LocalizedStringResource("We couldn't reach our server. Please try sending again shortly.")
    static let noProducts = LocalizedStringResource("No products to show yet.")
    static let noCategoryProducts = LocalizedStringResource("No products in this category yet.")
    static let retry = LocalizedStringResource("Try again")
    static let enquire = LocalizedStringResource("Enquire")
    static let searchPrompt = LocalizedStringResource("Search products")
    static let searchTitle = LocalizedStringResource("Search")
    static let searchHint = LocalizedStringResource("Start typing to find products.")
    static let enquiryTitle = LocalizedStringResource("Enquiry")
    static let nameField = LocalizedStringResource("Name")
    static let emailField = LocalizedStringResource("Email")
    static let phoneField = LocalizedStringResource("Phone (optional)")
    static let messageField = LocalizedStringResource("Message")
    static let submit = LocalizedStringResource("Send enquiry")
    static let thankYouTitle = LocalizedStringResource("Thank you")
    static let thankYouMessage = LocalizedStringResource("We've received your enquiry and will be in touch.")
    static let invalidName = LocalizedStringResource("Please enter your name.")
    static let invalidEmail = LocalizedStringResource("Please enter a valid email address.")
    static let invalidMessage = LocalizedStringResource("Please write a message.")
    static let sendFailed = LocalizedStringResource("We couldn't send your enquiry. Try again.")

    static func searchPrompt(in categoryName: String) -> LocalizedStringResource {
        LocalizedStringResource("Search \(categoryName)")
    }
}
