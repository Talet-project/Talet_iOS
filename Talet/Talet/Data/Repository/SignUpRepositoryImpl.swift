//
//  SignUpRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import RxSwift


final class SignUpRepositoryImpl: SignUpRepositoryProtocol {
    private let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
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
        .map { dto in
            LoginResultEntity(
                accessToken: dto.data?.accessToken,
                refreshToken: dto.data?.refreshToken,
                signUpToken: dto.data?.signUpToken,
                isSignUpNeeded: false)
        }
    }
}
    
