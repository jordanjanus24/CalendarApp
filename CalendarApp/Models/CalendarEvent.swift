//
//  CalendarEvent.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation

struct CalendarEvent: Codable {
    let id: String
    let eventName: String
    let description: String
    let date: Date
}
