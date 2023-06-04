//
//  AppCoordinator.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/1/23.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    let defaults = UserDefaults.standard
    
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        if let idToken = defaults.string(forKey: "idToken"), !idToken.isEmpty {
            return showCalendar()
        } else {
            let loginCoordinator = LoginCoordinator(window: self.window)
            return coordinate(to: loginCoordinator)
                .asObservable()
                .flatMap { [weak self] in return (self?.showCalendar())! }
        }
    }
    func showCalendar() -> Observable<Void> {
        let calendarCoordinator = CalendarCoordinator(window: self.window)
        return coordinate(to: calendarCoordinator)
            .asObservable()
            .flatMap { [weak self] in return (self?.start())! }
    }
}
