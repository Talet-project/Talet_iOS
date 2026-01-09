//
//  MockTokenManager.swift
//  TaletTests
//

import Foundation
@testable import Talet

final class MockTokenManager: TokenManagerProtocol {
    var accessToken: String?
    var refreshToken: String?

    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
