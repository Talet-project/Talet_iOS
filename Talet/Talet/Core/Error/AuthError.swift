//
//  AuthError.swift
//  Talet
//
//  Created by 김승희 on 12/16/25.
//

enum AuthError: Error {
    case noToken
    case expired
    case invalid
}
