//
//  LoginRepositoryImpl.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

import RxSwift


final class LoginRepositoryImpl: LoginRepositoryProtocol {
    private let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity> {
        return network.request(endpoint: "/auth/apple",
                               method: .post,
                               body: LoginRequestDTO(idToken: socialToken.socialToken),
                               headers: nil,
                               responseType: LoginResponseDTO.self
        )
        .map { dto in
            LoginResultEntity(accessToken: dto.data?.accessToken,
                              refreshToken: dto.data?.refreshToken,
                              signUpToken: dto.data?.signUpToken,
                              // 현재 네트워크매니저 구조상 200, 201 서버코드 말고 일단 signUpToken 유무로 분기
                              isSignUpNeeded: dto.data?.signUpToken != nil)
        }
    }
    
    
}
