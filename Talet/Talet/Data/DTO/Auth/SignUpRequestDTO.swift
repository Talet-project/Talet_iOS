//
//  SignUpRequestDTO.swift
//  Talet
//
//  Created by 김승희 on 11/30/25.
//

struct SignUpRequestDTO: Encodable {
    let name: String
    let birthDate: String
    let gender: String
    let nativeLanguages: [String]
}
