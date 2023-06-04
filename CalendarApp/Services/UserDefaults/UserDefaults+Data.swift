//
//  UserDefaults.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case idToken
        case userId
        case email
        case refreshToken
    }
    func setValue(_ value: Any, key: UserDefaults.Keys) {
        self.set(value, forKey: key.rawValue)
    }

    func reset() {
        Keys.allCases.forEach { self.removeObject(forKey: $0.rawValue) }
    }

}
