//
//  SignUpRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 12/1/25.
//

import RxSwift


protocol SignUpRepositoryProtocol {
    func signUp(SignUpString: String, request: UserEntity) -> Single<LoginResultEntity>
}
