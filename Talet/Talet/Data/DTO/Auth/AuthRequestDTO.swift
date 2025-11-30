//
//  AuthRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 11/26/25.
//

struct AuthRequestDTO: Encodable {
    let name: String
    let birthDate: String
    let gender: String
    let nativeLanguages: [String]
}
