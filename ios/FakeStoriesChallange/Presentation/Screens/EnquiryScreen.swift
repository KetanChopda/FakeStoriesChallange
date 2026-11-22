//
//  EnquiryScreen.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import SwiftUI

/// Enquiry form for one product; shows a thank-you once the enquiry is sent.
struct EnquiryScreen: View {
    @State private var viewModel: EnquiryViewModel

    init(viewModel: EnquiryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var model = viewModel
        Group {
            if viewModel.status == .sent {
                ContentUnavailableView {
                    Label(Copy.thankYouTitle, systemImage: Theme.Symbol.success)
                } description: {
                    Text(Copy.thankYouMessage)
                }
            } else {
                Form {
                    Section {
                        TextField(text: $model.name) {
                            Text(Copy.nameField)
                        }
                        .textContentType(.name)

                        TextField(text: $model.email) {
                            Text(Copy.emailField)
                        }
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                        TextField(text: $model.phone) {
                            Text(Copy.phoneField)
                        }
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)

                        TextField(text: $model.message, axis: .vertical) {
                            Text(Copy.messageField)
                        }
                        .lineLimit(Theme.Form.messageLines, reservesSpace: true)
                    }

                    Section {
                        if let problem = problemText {
                            Text(problem)
                                .foregroundStyle(.red)
                        }
                        Button {
                            Task { await viewModel.submit() }
                        } label: {
                            if viewModel.status == .sending {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text(Copy.submit)
                            }
                        }
                        .disabled(viewModel.status == .sending)
                    }
                }
            }
        }
        .navigationTitle(Copy.enquiryTitle)
    }

    /// Maps the last submit outcome to a message; nothing shows while editing.
    private var problemText: LocalizedStringResource? {
        switch viewModel.status {
        case .invalid(.emptyName): Copy.invalidName
        case .invalid(.invalidEmail): Copy.invalidEmail
        case .invalid(.emptyMessage): Copy.invalidMessage
        case .failed(let failure): failure.enquiryMessage
        case .editing, .sending, .sent: nil
        }
    }
}
