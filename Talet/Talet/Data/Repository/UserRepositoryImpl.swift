//
//  UserRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import Foundation

import RxSwift


final class UserRepositoryImpl: UserRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let tokenManager: TokenManagerProtocol

    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        tokenManager: TokenManagerProtocol = TokenManager.shared
    ) {
        self.networkManager = networkManager
        self.tokenManager = tokenManager
    }

    func fetchUserInfo() -> Single<UserEntity> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return networkManager.request(
            endpoint: "/member/me",
            method: .get,
            body: nil,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: UserInfoResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }

    // MARK: - Update Info

    func updateUserInfo(request user: UserEntity) -> Single<UserEntity> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }

        let requestDTO = UserUpdateRequestDTO(from: user)

        return networkManager.request(
            endpoint: "/member/update",
            method: .post,
            body: requestDTO,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: UserInfoResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }

    // MARK: - Update Image

    func updateUserImage(imageData: Data) -> Single<UserEntity> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }

        return networkManager.upload(
            endpoint: "/member/update/image",
            imageData: imageData,
            headers: ["Authorization": "Bearer \(accessToken)"],
            responseType: UserInfoResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }
}
