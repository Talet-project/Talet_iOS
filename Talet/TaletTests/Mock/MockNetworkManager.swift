//
//  MockNetworkManager.swift
//  TaletTests
//

import Foundation
import RxSwift
import Alamofire
@testable import Talet

final class MockNetworkManager: NetworkManagerProtocol {

    // MARK: - Tracking

    var requestCallCount = 0
    var uploadCallCount = 0
    var lastEndpoint: String?
    var lastMethod: HTTPMethod?
    var lastHeaders: [String: String]?

    // MARK: - Stubbed Responses

    var stubbedResult: Any?
    var stubbedError: Error?

    // MARK: - NetworkManagerProtocol

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String: String]?,
        responseType: T.Type
    ) -> Single<T> {
        requestCallCount += 1
        lastEndpoint = endpoint
        lastMethod = method
        lastHeaders = headers

        if let error = stubbedError {
            return .error(error)
        }

        if let result = stubbedResult as? T {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    func upload<T: Decodable>(
        endpoint: String,
        imageData: Data,
        headers: [String: String]?,
        responseType: T.Type
    ) -> Single<T> {
        uploadCallCount += 1
        lastEndpoint = endpoint
        lastHeaders = headers

        if let error = stubbedError {
            return .error(error)
        }

        if let result = stubbedResult as? T {
            return .just(result)
        }

        return .error(NetworkError.unknown)
    }

    // MARK: - Helpers

    func reset() {
        requestCallCount = 0
        uploadCallCount = 0
        lastEndpoint = nil
        lastMethod = nil
        lastHeaders = nil
        stubbedResult = nil
        stubbedError = nil
    }
}
