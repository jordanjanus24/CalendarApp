//
//  LoginCoordinator.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import RxSwift

enum LoginResult {
    case signup
    case login
    case homepage
}

class LoginCoordinator: BaseCoordinator<Void> {
    
    lazy var viewModel: LoginViewModel = LoginViewModel()
    lazy var module: LoginModuleProtocol = LoginModule(viewModel: viewModel)
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
        _ = viewModel.didShowSignup
            .subscribe(onNext: { [weak self] in
                self?.showSignupModule()
            })
            .disposed(by: disposeBag)
        
        _ = viewModel.didShowLogin
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        let didShowHomepage = viewModel.didShowHomepage
            .observeOnMain()
        return Observable.merge(didShowHomepage)
            
    }
    func showSignupModule()  {
        module.signupFlow(self.navigationController)
    }
}
