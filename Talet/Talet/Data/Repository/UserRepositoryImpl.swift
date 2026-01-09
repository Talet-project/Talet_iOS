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
        .flatMap { response in
            guard let dto = response.data else {
                if let error = response.error {
                    return .error(NetworkError.detailedError(error))
                }
                return .error(NetworkError.unknown)
            }
            
            do {
                let entity = UserEntity(
                    name: dto.nickname,
                    birth: dto.birthday,
                    gender: try GenderMapper.fromAPI(dto.gender),
                    profileImage: dto.profileImage,
                    languages: dto.languages.compactMap(LanguageMapper.fromAPI)
                )
                return .just(entity)
            } catch {
                return .error(error)
            }
        }
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
        .flatMap { response in
            guard let dto = response.data else {
                if let error = response.error {
                    return .error(NetworkError.detailedError(error))
                }
                return .error(NetworkError.unknown)
            }
            
            do {
                let entity = UserEntity(
                    name: dto.nickname,
                    birth: dto.birthday,
                    gender: try GenderMapper.fromAPI(dto.gender),
                    profileImage: dto.profileImage,
                    languages: dto.languages.compactMap(LanguageMapper.fromAPI)
                )
                return .just(entity)
            } catch {
                return .error(error)
            }
        }
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
        .flatMap { response in
            guard let dto = response.data else {
                if let error = response.error {
                    return .error(NetworkError.detailedError(error))
                }
                return .error(NetworkError.unknown)
            }
            
            do {
                let entity = UserEntity(
                    name: dto.nickname,
                    birth: dto.birthday,
                    gender: try GenderMapper.fromAPI(dto.gender),
                    profileImage: dto.profileImage,
                    languages: dto.languages.compactMap(LanguageMapper.fromAPI)
                )
                return .just(entity)
            } catch {
                return .error(error)
            }
        }
    }
}
