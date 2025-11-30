//
//  LoginRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 11/17/25.
//

import RxSwift


protocol LoginRepositoryProtocol {
    func socialLogin(socialToken: SocialTokenEntity) -> Single<LoginResultEntity>
}
