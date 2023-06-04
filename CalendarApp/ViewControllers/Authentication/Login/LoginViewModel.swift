//
//  LoginViewModel.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import RxSwift



class LoginViewModel {
    let service = AuthService()
    let defaults = UserDefaults.standard
    // MARK: - Inputs
    let showSignup: AnyObserver<Void>
    let showLogin: AnyObserver<Void>
    let showAlert: AnyObserver<String>
    let showHomepage: AnyObserver<Void>
    // MARK: - Outputs
    let didShowSignup: Observable<Void>
    let didShowLogin: Observable<Void>
    let didShowAlert: Observable<String>
    let didShowHomepage: Observable<Void>
    init() {
        let _showSignup = PublishSubject<Void>()
        self.showSignup = _showSignup.asObserver()
        self.didShowSignup = _showSignup.asObservable()
        
        let _showLogin = PublishSubject<Void>()
        self.showLogin = _showLogin.asObserver()
        self.didShowLogin = _showLogin.asObservable()
        
        let _showAlert = PublishSubject<String>()
        self.showAlert = _showAlert.asObserver()
        self.didShowAlert = _showAlert.asObservable()
        
        let _showHomepage = PublishSubject<Void>()
        self.showHomepage = _showHomepage.asObserver()
        self.didShowHomepage = _showHomepage.asObservable()
    }
    
    func authenticate(_ email: String, with password: String) {
        _ = service.authenticate(user: User(email: email, password: password), action: "signInWithPassword")
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.persistUser(result)
                    self?.showHomepage.onNext(())
                } else {
                    self?.showAlert.onNext("Something went wrong.")
                }
            })
    }
    func signup(_ email: String, with password: String) {
        _ = service.authenticate(user: User(email: email, password: password), action: "signUp")
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.persistUser(result)
                    self?.showHomepage.onNext(())
                } else {
                    self?.showAlert.onNext("Something went wrong.")
                }
            })
    }
    private func persistUser(_ session: AuthSession) {
        self.defaults.setValue(session.idToken, key: .idToken)
        self.defaults.setValue(session.localId, key: .userId)
        self.defaults.setValue(session.email, key: .email)
        self.defaults.setValue(session.refreshToken, key: .refreshToken)
        self.defaults.synchronize()
    }
}
