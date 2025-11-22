//
//  UserInfoRequest.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/19/25.
//


struct UserInfoRequest: Codable {
    let UserName:String?
    let oldPassword:String?
    let newPassword:Bool?
}
