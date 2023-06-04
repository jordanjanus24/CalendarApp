//
//  EventKit+Permission.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/4/23.
//

import Foundation
import EventKit

extension EKEventStore {
    func makeSureGranted(completion: @escaping () -> Void) {
        self.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil)
            {
                completion()
            }
        }
    }
}
