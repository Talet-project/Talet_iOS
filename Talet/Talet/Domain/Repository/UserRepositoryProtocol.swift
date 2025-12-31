//
//  UserRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import Foundation

import RxSwift


protocol UserRepositoryProtocol: AnyObject {
    func fetchUserInfo() -> Single<UserEntity>
    func updateUserInfo(request: UserEntity) -> Single<UserEntity>
    func updateUserImage(imageData: Data) -> Single<UserEntity>
}
