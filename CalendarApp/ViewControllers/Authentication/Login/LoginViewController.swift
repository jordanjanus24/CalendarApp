//
//  LoginViewController.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    private func setupBindings() {
        signupButton.rx.tap
            .bind(to: viewModel.showSignup)
            .disposed(by: disposeBag)
        
        _ = viewModel.didShowAlert
            .observeOnMain()
            .subscribe(onNext: { [weak self]  message in
                self?.showSimpleAlert(title: "Calendar", message: message)
            })
    }
    
    @IBAction func loginTap(_ sender: Any) {
        guard
            let username = emailField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
            viewModel.showAlert.onNext("Please input all fields.")
            return
        }
        viewModel.authenticate(username, with: password)
    }
}
