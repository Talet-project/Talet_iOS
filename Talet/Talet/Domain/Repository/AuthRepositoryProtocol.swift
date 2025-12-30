//
//  AuthRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 11/17/25.
//

import RxSwift


protocol AuthRepositoryProtocol {
    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity>
    func validateAccessToken() -> Single<Void>
    func refreshAccessToken() -> Single<Void>
    func signUp(SignUpString: String, request: UserEntity) -> Single<LoginResultEntity>
}
