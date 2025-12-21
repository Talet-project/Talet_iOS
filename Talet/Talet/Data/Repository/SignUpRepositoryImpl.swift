//
//  SignUpRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import RxSwift


final class SignUpRepositoryImpl: SignUpRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(network: NetworkManagerProtocol, tokenManager: TokenManagerProtocol) {
        self.network = network
        self.tokenManager = tokenManager
    }
    
    func signUp(SignUpString: String,
                request: UserEntity) -> Single<LoginResultEntity> {
        
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
}
    
