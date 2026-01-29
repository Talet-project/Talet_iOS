//
//  AuthRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private var tokenManager: TokenManagerProtocol

    init(
        network: NetworkManagerProtocol = NetworkManager.shared,
        tokenManager: TokenManagerProtocol = TokenManager.shared
    ) {
        self.network = network
        self.tokenManager = tokenManager
    }
    
    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity> {
        return network.request(
            endpoint: "/auth/apple",
            method: .post,
            body: LoginRequestDTO(idToken: socialToken.socialToken),
            headers: nil,
            responseType: LoginResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }
    
    func validateAccessToken() -> Single<Void> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.requestVoid(
            endpoint: "/auth/validate",
            method: .get,
            body: nil,
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }
    
    func refreshAccessToken() -> Single<TokenEntity> {
        print("refreshAccessToken called")
        guard let refreshToken = tokenManager.refreshToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/auth/refresh",
            method: .post,
            body: nil as String?,
            headers: [
                "Authorization": "Bearer \(refreshToken)"
            ],
            responseType: RefreshResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }
    
    func signUp(SignUpString: String, request: UserEntity) -> Single<LoginResultEntity> {
        
        let headers = [
            "Authorization": "Bearer \(SignUpString)"
        ]
        
        let requestDTO = SignUpRequestDTO(from: request)
        
        return network.request(
            endpoint: "/auth/apple/sign-up",
            method: .post,
            body: requestDTO,
            headers: headers,
            responseType: SignUpResponseDTO.self
        )
        .map { try $0.unwrapData().toEntity() }
    }
    
    func logout() -> Single<Void> {
        
        guard let token = self.tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        return network.requestVoid(
            endpoint: "/auth/logout",
            method: .post,
            body: nil,
            headers: headers
        )
    }
    
    func deleteAccount() -> Single<Void> {
        guard let token = self.tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        return network.requestVoid(
            endpoint: "/auth/delete",
            method: .delete,
            body: nil,
            headers: headers
        )
    }
}
