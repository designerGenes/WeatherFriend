//
//  EmailUsView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import SwiftUI
import Combine

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    @State var textColor: UIColor

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = UIColor.clear // Set background color here
        textView.textColor = textColor
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor

        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

struct EmailUsView<ViewModel: EmailUsViewModelType>: View {
    @StateObject var viewModel: ViewModel
    @Binding var isShowing: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var keyboardObserver = KeyboardObserver()
    
    var BlurredBackground: some View {
        Color(uiColor: .darkGray)
            .blur(radius: 1)
            .animation(.easeInOut, value: 0.25)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    var ControlRow: some View {
        HStack {
            Spacer()
            Group {
                Button("Submit") {
                    viewModel.sendEmail()
                    isShowing = false
                }
                
                Button("Cancel") {
                    isShowing = false
                }
                
            }
            .foregroundColor(Color(uiColor: .primaryLinkButtonColor))
            .font(.headline)
            
        }
        .padding()
        .cornerRadius(10)
        .foregroundColor(Color(uiColor: .primaryBackgroundColor))
    }
    
    var body: some View {
        ZStack {
            BlurredBackground
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        Text("Email the developer")
                            .font(.title)
                        Spacer()
                    }
                    .padding([.leading, .trailing], 8)
                    VStack(spacing: 20) {
                        CustomTextEditor(text: $viewModel.text, textColor: UIColor.primaryTextColor)
                            .padding([.leading, .trailing], 8)
                        ControlRow
                    }
                    .background(Color(uiColor: .primaryBackgroundColor))
                    .cornerRadius(10)
                    .frame(maxHeight: UIScreen.main.bounds.height / 2)
                    .offset(y: -keyboardObserver.keyboardHeight)
                    .animation(.easeInOut, value: keyboardObserver.keyboardHeight)
                    
                }
                .offset(y: -keyboardObserver.keyboardHeight)
                .frame(height: UIScreen.main.bounds.height - keyboardObserver.keyboardHeight)
                .animation(.easeOut(duration: 0.16))
            }
            
        }
        
        .ignoresSafeArea()
        .onReceive(viewModel.objectWillChange) { _ in
            if !isShowing || viewModel.namedError != nil {
                dismiss()
            }
        }
    }
}


#if DEBUG
struct EmailUsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EmailUsView(viewModel: MockEmailUsViewModel(namedError: .settings_email_error, isShowing: true, text: "This is a test email"), isShowing: .constant(true))
        }
        .background(Color(uiColor: .primaryBackgroundColor))
    }
    
}
#endif
