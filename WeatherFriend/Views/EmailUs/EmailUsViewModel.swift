//
//  EmailUsViewModel.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/24/23.
//

import Foundation
import Combine
import SwiftUI

typealias BasicTask = Task<Void, Never>
protocol EmailUsViewModelType: ObservableObject {
    var text: String { get set }
    func sendEmail()
    var namedError: NamedError? { get set }
    var isShowing: Bool { get set }
}


extension EmailUsViewModelType {
    var emailEndpoint: String {
        Bundle.main.plistValue(for: .awsEmailURL)
    }
}

enum HTTPError: Error {
    case badResponse(statusCode: URLResponse?)
}

class MockEmailUsViewModel: EmailUsViewModelType {
    @Published var namedError: NamedError?
    @Published var isShowing: Bool
    var text: String
    
    init(namedError: NamedError? = nil, isShowing: Bool = false, text: String = "") {
        self.namedError = namedError
        self.isShowing = isShowing
        self.text = text
    }
    
    func sendEmail()  {
        Task {
            do {
                // Simulate a 2-second delay for the email to be sent
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // Sleep takes nanoseconds
                // If the operation is successful
                namedError = nil
                self.isShowing = false
            } catch {
                // Handle any errors
                namedError = .settings_email_error
            }
        }
    }
}

enum EmailBodyKey: String {
    case emailText, emailSubject, emailFrom
    case emailFromValue = "appfeedback.designergenes@gmail.com"
    case emailSubjectValue = "New App Response Submission"
}

class EmailUsViewModel: ObservableObject, EmailUsViewModelType {
    
    @Published var text = ""
    @Published var isShowing: Bool = true
    @Published var namedError: NamedError?
    
    private func buildEmailData() -> Data? {
        
        let body: [String: Any] = [
            EmailBodyKey.emailText.rawValue: self.text,
            EmailBodyKey.emailSubject.rawValue: EmailBodyKey.emailSubjectValue.rawValue,
            EmailBodyKey.emailFrom.rawValue: EmailBodyKey.emailFromValue.rawValue
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        return bodyData
    }
    
    private func buildEmailRequest(data: Data?) -> URLRequest {
        let url = URL(string: self.emailEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func sendEmail() {
        Task {
            do {
                let bodyData = self.buildEmailData()
                let request = self.buildEmailRequest(data: bodyData)
                
                let (_, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    self.isShowing = false
                } else {
                    self.namedError = .settings_email_error
                }
            } catch {
                self.namedError = .settings_email_error
            }
        }
        // Removed cancellables.insert(postTask) as Task doesn't need to be stored in most cases
    }
}
