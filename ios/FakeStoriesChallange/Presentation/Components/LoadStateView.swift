//
//  LoadStateView.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Shows progress, a retry prompt, or the loaded content, so each screen handles state the same way.
struct LoadStateView<Value: Equatable & Sendable, Content: View>: View {
    let state: LoadState<Value>
    let retry: @MainActor () async -> Void
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(Theme.Spacing.medium)
        case .loaded(let value):
            content(value)
        case .failed(let failure):
            ContentUnavailableView {
                Label(failure.message, systemImage: failure.symbol)
            } actions: {
                Button {
                    Task { await retry() }
                } label: {
                    Text(Copy.retry)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
