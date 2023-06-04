//
//  CalendarCoordinator.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import RxSwift

class CalendarCoordinator: BaseCoordinator<Void> {
    let defaults = UserDefaults.standard
    lazy var viewModel: CalendarViewModel = CalendarViewModel()
    lazy var module: CalendarModuleProtocol = CalendarModule(viewModel: viewModel)
    
    internal var window: UIWindow
    internal var navigationController: UINavigationController = UINavigationController()
    
    required init(window: UIWindow) {
        self.window = window
        super.init()
    }
    override func start() -> Observable<Void> {
        module.startInitialFlow(navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let didLogout = viewModel.didLogout
            .observeOnMain()
        
        _ = viewModel.didShowPopup
            .observeOnMain()
            .subscribe(onNext: { [weak self] in
                self?.module.startEventPopup(event: nil)
            })
        _ = viewModel.onSelectedEvent
            .observeOnMain()
            .subscribe(onNext: { [weak self] event in
                self?.module.startEventPopup(event: event)
            })
        
        return Observable.merge(didLogout)
    }
    
}
