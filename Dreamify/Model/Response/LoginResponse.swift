//
//  LoginResponse.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//

struct LoginResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let isFirstLogin:Bool
    let userId:String

}
