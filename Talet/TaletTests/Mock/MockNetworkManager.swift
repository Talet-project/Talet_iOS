//
//  MockNetworkManager.swift
//  TaletTests
//

import Alamofire
import RxSwift
@testable import Talet
import Foundation


final class MockNetworkManager: NetworkManagerProtocol {

    // MARK: - Configurable Results

    var requestResult: Any!
    var requestVoidResult: Single<Void> = .just(())
    var uploadResult: Any!

    // MARK: - Call Tracking

    var requestCallCount = 0
    var requestVoidCallCount = 0
    var uploadCallCount = 0
    var lastEndpoint: String?
    var lastMethod: HTTPMethod?
    var lastHeaders: [String: String]?

    // MARK: - Protocol Methods

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
        return requestResult as! Single<T>
    }

    func requestVoid(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String: String]?
    ) -> Single<Void> {
        requestVoidCallCount += 1
        lastEndpoint = endpoint
        lastMethod = method
        lastHeaders = headers
        return requestVoidResult
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
        return uploadResult as! Single<T>
    }
}
