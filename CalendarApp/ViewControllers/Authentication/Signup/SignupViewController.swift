//
//  SignupViewController.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setupBindings() {
        loginButton.rx.tap
            .bind(to: viewModel.showLogin)
            .disposed(by: disposeBag)
        
        _ = viewModel.didShowAlert
            .observeOnMain()
            .subscribe(onNext: { [weak self]  message in
                self?.showSimpleAlert(title: "Calendar", message: message)
            })
    }
    
    @IBAction func signupTap(_ sender: Any) {
        guard
            let username = emailField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let confirmPass = confirmPasswordField.text, !confirmPass.isEmpty else {
            viewModel.showAlert.onNext("Please input all fields.")
            return
        }
        if password != confirmPass {
            viewModel.showAlert.onNext("Please confirm password.")
        } else {
            viewModel.signup(username, with: password)
        }
    }
}
