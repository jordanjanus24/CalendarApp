//
//  LoginModule.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/2/23.
//

import Foundation
import UIKit

protocol LoginModuleProtocol {
    func startInitialFlow(_ navController: UINavigationController)
    func signupFlow(_ navController: UINavigationController)
}

class LoginModule: LoginModuleProtocol {
    
    internal var viewModel: LoginViewModel!
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    func startInitialFlow(_ navController: UINavigationController) {
        let vc = LoginViewController.instantiate()
        vc.viewModel = viewModel
        navController.pushViewController(vc, animated: true)
    }
    func signupFlow(_ navController: UINavigationController) {
        let vc = SignupViewController.instantiate()
        vc.viewModel = viewModel
        navController.pushViewController(vc, animated: true)
    }
}
