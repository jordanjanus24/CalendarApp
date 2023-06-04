//
//  User.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation

struct User: Encodable {
    var email: String = ""
    var password: String = ""
    var confirmPass: String = ""
    let returnSecureToken: Bool = true
}
struct AuthSession: Decodable {
    let localId: String
    let email: String
    let idToken: String
    let refreshToken: String
}
