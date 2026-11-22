//
//  EnquiryViewModelTests.swift
//  FakeStoriesChallange
//
//  Created by Ketan on 22/11/26.
//

import Testing
@testable import FakeStoriesChallange

@MainActor
@Suite struct EnquiryViewModelTests {

    private func makeViewModel(service: any EnquiryService) -> EnquiryViewModel {
        let viewModel = EnquiryViewModel(productID: 1, submitEnquiry: SubmitEnquiry(service: service))
        viewModel.name = "Ada Lovelace"
        viewModel.email = "ada@example.com"
        viewModel.message = "Is this in stock?"
        return viewModel
    }

    @Test func `Valid enquiry is sent and marked as sent`() async throws {
        let service = RecordingEnquiryService()
        let viewModel = makeViewModel(service: service)

        await viewModel.submit()

        #expect(viewModel.status == .sent)
        #expect(await service.submitted.count == 1)
    }

    @Test func `Invalid enquiry reports the validation error and sends nothing`() async throws {
        let service = RecordingEnquiryService()
        let viewModel = makeViewModel(service: service)
        viewModel.email = "not-an-email"

        await viewModel.submit()

        #expect(viewModel.status == .invalid(.invalidEmail))
        #expect(await service.submitted.isEmpty)
    }

    @Test func `Delivery failure marks the enquiry as failed`() async throws {
        let viewModel = makeViewModel(service: FailingEnquiryService())

        await viewModel.submit()

        #expect(viewModel.status == .failed(.unknown))
    }

    @Test func `Offline send reports an offline failure`() async throws {
        let viewModel = makeViewModel(service: FailingEnquiryService(failure: .offline))

        await viewModel.submit()

        #expect(viewModel.status == .failed(.offline))
    }

    @Test func `Server rejection reports a server failure`() async throws {
        let viewModel = makeViewModel(service: FailingEnquiryService(failure: .server))

        await viewModel.submit()

        #expect(viewModel.status == .failed(.server))
    }

    @Test func `An empty phone number is sent as no phone`() async throws {
        let service = RecordingEnquiryService()
        let viewModel = makeViewModel(service: service)
        viewModel.phone = ""

        await viewModel.submit()

        #expect(await service.submitted.first?.contact.phone == nil)
    }

    @Test func `Status is sending while the enquiry is in flight`() async throws {
        let service = GatedEnquiryService()
        let viewModel = makeViewModel(service: service)

        let send = Task { await viewModel.submit() }
        await service.waitUntilEntered()
        #expect(viewModel.status == .sending)

        await service.release()
        await send.value
        #expect(viewModel.status == .sent)
    }
}
