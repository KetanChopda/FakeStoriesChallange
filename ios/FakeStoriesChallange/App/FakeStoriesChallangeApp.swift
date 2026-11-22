//
//  FakeStoriesChallangeApp.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

@main
struct FakeStoriesChallangeApp: App {
    private let container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
