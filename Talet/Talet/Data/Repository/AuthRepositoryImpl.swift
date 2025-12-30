//
//  AuthRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(network: NetworkManagerProtocol, tokenManager: TokenManagerProtocol) {
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
        // .do: 반환된 Single<LoginResponseDTO>를 사용해 실제로 작업들을 수행
        .do(onSuccess: { [weak self] (response: LoginResponseDTO) in
            if response.data?.signUpToken == nil {
                if let accessToken = response.data?.accessToken {
                    self?.tokenManager.accessToken = accessToken
                }
                if let refreshToken = response.data?.refreshToken {
                    self?.tokenManager.refreshToken = refreshToken
                }
            }
        })
        // .map: 반환된 Single<LoginResponseDTO>를 LoginResultEntity에 매핑
        .map { response in
            LoginResultEntity(
                accessToken: response.data?.accessToken,
                refreshToken: response.data?.refreshToken,
                signUpToken: response.data?.signUpToken,
                isSignUpNeeded: response.data?.signUpToken != nil
            )
        }
    }
    
    func validateAccessToken() -> Single<Void> {
        guard let accessToken = tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        return network.request(
            endpoint: "/auth/validate",
            method: .get,
            body: nil,
            headers: [
                "Authorization": "Bearer \(accessToken)"
            ],
            responseType: EmptyResponse.self
        )
        .map { _ in () } // <Void> 으로 변환
    }
    
    func refreshAccessToken() -> Single<Void> {
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
        .do(onSuccess: { [weak self] response in
            print("받아오는데까지 갔음")
            guard let data = response.data else { return }
            self?.tokenManager.accessToken = data.accessToken
            self?.tokenManager.refreshToken = data.refreshToken
        })
        .map { _ in () }
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
        .do(onSuccess: { [weak self] (response: SignUpResponseDTO) in
            guard let data = response.data else { return }
            self?.tokenManager.accessToken = data.accessToken
            self?.tokenManager.refreshToken = data.refreshToken
        })
        .map { dto in
            LoginResultEntity(
                accessToken: dto.data?.accessToken,
                refreshToken: dto.data?.refreshToken,
                signUpToken: dto.data?.signUpToken,
                isSignUpNeeded: false)
        }
    }
    
    func logout() -> Single<Void> {
        
        guard let token = self.tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        return network.request(
            endpoint: "/auth/logout",
            method: .post,
            body: nil,
            headers: headers,
            responseType: EmptyResponse.self
        )
        .map { _ in () }
    }
    
    func deleteAccount() -> Single<Void> {
        guard let token = self.tokenManager.accessToken else {
            return .error(AuthError.noToken)
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        return network.request(
            endpoint: "/auth/delete",
            method: .delete,
            body: nil,
            headers: headers,
            responseType: EmptyResponse.self
        )
        .map { _ in () }
    }
}
