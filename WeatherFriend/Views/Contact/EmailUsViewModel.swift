//
//  EmailUsViewModel.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/24/23.
//

import Foundation
import Combine
import SwiftUI

protocol EmailUsViewModelType: ObservableObject {
    var text: String { get set }
    func sendEmail() -> AnyPublisher<Void, Error>
    var isShowing: Bool { get set }
}

enum HTTPError: Error {
    case badResponse(statusCode: URLResponse?)
}

class MockEmailUsViewModel: EmailUsViewModelType {
    @Binding var isShowing: Bool
    var text: String = "Here is a mock email us view model."
    
    init(isShowing: Bool, text: String) {
        self.isShowing = isShowing
        self.text = text
    }
    
    func sendEmail() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    static func mock() -> MockEmailUsViewModel {
        return MockEmailUsViewModel(isShowing: true, text: "some email text")
    }
}

enum EmailBodyKey: String {
    case emailText, emailSubject, emailFrom
    case emailFromValue = "appfeedback.designergenes@gmail.com"
    case emailSubjectValue = "New App Response Submission"
}

class EmailUsViewModel: ObservableObject, EmailUsViewModelType {
    @Published var text = ""
    @Binding var isShowing: Bool
    private let emailEndpoint = Bundle.main.object(forInfoDictionaryKey: "AWS_EMAIL_URL") as! String
    private var cancellables: Set<AnyCancellable>

    init(text: String = "", isShowing: Binding<Bool>, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.text = text
        self._isShowing = isShowing
        self.cancellables = cancellables
    }
    
    func sendEmail() -> AnyPublisher<Void, Error> {
        let publisher = Future<Void, Error> { promise in
            Task {
                do {
                    let url = URL(string: self.emailEndpoint)!
                    var request = URLRequest(url: url)
                    
                    let body: [String: Any] = [
                        EmailBodyKey.emailText.rawValue: self.text,
                        EmailBodyKey.emailSubject.rawValue: EmailBodyKey.emailSubjectValue.rawValue,
                        EmailBodyKey.emailFrom.rawValue: EmailBodyKey.emailFromValue.rawValue
                    ]
                    let bodyData = try JSONSerialization.data(withJSONObject: body)
                    request.httpMethod = "POST"
                    request.httpBody = bodyData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let (_, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        promise(.failure(HTTPError.badResponse(statusCode: response)))
                        return
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()

        return publisher
    }
}
