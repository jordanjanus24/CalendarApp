//
//  Observable+Extensions.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import RxSwift

extension ObservableType {
    func observeOnMain() -> Observable<Element> {
        return self.observe(on: MainScheduler.instance)
    }
}
