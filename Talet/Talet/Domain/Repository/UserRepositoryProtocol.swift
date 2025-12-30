//
//  UserRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import RxSwift


protocol UserRepositoryProtocol: AnyObject {
    func fetchUserInfo() -> Single<UserEntity>
}
