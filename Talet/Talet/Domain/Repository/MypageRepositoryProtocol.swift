//
//  MypageRepositoryProtocol.swift
//  Talet
//
//  Created by 김승희 on 12/28/25.
//

import RxSwift


protocol MypageRepositoryProtocol: AnyObject {
    func fetchUserInfo() -> Single<UserEntity>
}
