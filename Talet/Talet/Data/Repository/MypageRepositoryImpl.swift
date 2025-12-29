//
//  MypageRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import RxSwift


class MypageRepositoryImpl: MypageRepositoryProtocol {
    private let tokenManager: TokenManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(tokenManager: TokenManagerProtocol,
         networkManager: NetworkManagerProtocol) {
        self.tokenManager = tokenManager
        self.networkManager = networkManager
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
            guard let data = response.data else {
                if let error = response.error {
                    return .error(NetworkError.detailedError(error))
                }
                return .error(NetworkError.unknown)
            }
            return .just(try data.toEntity())
        }
    }
}
