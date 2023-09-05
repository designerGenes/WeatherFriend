import UIKit
import SwiftUI



struct OpenAIConversationView: View {
    
    @Binding var messages: [OpenAIConversationMessage]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(messages.filter({ $0.role != .system })) { message in
                    HStack {
                        if message.role == .assistant {
                            Text(message.roleString)
                                .foregroundColor(.blue)
                        } else {
                            Text(message.roleString)
                        }
                        
                        Text(message.content)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            .padding()
        }
        .background {
            Color.white
        }
        
    }
}

