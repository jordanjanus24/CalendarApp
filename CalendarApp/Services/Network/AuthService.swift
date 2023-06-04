//
//  AuthService.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import RxSwift

let API_KEY = "AIzaSyAAnCIcLd9qgWrfSZla3znGh9dHsd9TDVc"

class AuthService {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    func authenticate(user: User, action: String = "signInWithPassword") -> Observable<AuthSession?> {
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:\(action)?key=\(API_KEY)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        return session.rx
            .response(request: urlRequest)
            .flatMap { (response: HTTPURLResponse, data: Data) -> Observable<AuthSession?> in
                if 200 ..< 300 ~= response.statusCode {
                    let data = try? JSONDecoder().decode(AuthSession.self, from: data)
                    return Observable.just(data)
                }
                return Observable.just(nil)
            }
    }
    
}
