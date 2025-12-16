//
//  LoginRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


final class LoginRepositoryImpl: LoginRepositoryProtocol {
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
}
