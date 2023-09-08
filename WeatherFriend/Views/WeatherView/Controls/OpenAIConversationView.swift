import UIKit
import SwiftUI

protocol OpenAIConversationViewDelegate {
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async
}

protocol OpenAIConversationViewType {
    
}

struct OpenAIConversationView: View, OpenAIConversationViewType {
    @State var loadingProgress: Double = -1
    @State var rolesToHide: [OpenAIRole] = [.system]
    @State var roleColors: [OpenAIRole : Color] = [
        .assistant: Color.blue,
        .user: .lightOrange,
        .system: .clear,
        .localSystem: .red
    ]
    @Binding var messages: [OpenAIConversationMessage]
    
    private var isLoading: Bool {
        return loadingProgress >= 0 && loadingProgress < 1
    }
    
    var delegate: OpenAIConversationViewDelegate?
    
    var filteredMessages: [OpenAIConversationMessage] {
        messages.filter({ message in rolesToHide.filter({$0 == message.role}).isEmpty })
    }
    
    
    var ControlBar: some View {
        HStack {
            Spacer()
            Group {
                TintChangingButton(title: OpenAICommand.yes.rawValue.uppercased(),
                                   iconImage: Image(systemName: "checkmark.circle"),
                                   isFrozen: isLoading,
                                   action: {
                    Task {
                        await delegate?.didSubmitConversationCommand(view: self, command: .yes)
                    }
                })
                
                TintChangingButton(title: OpenAICommand.no.rawValue.uppercased(),
                                   iconImage: Image(systemName: "x.circle"), 
                                   isFrozen: isLoading,
                                   action: {
                    Task {
                        await delegate?.didSubmitConversationCommand(view: self, command: .no)
                    }
                })
                TintChangingButton(title: OpenAICommand.retry.rawValue.uppercased(),
                                   iconImage: Image(systemName: "ellipsis.bubble.fill"),
                                   isFrozen: isLoading,
                                   action: {
                    Task {
                        await delegate?.didSubmitConversationCommand(view: self, command: .retry)
                    }
                })
            }
            .disabled(isLoading)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            
        }
        .background {
            Color.clear
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(filteredMessages) { message in
                        OpenAIMessageView(message: message, roleColor: roleColors[message.role]!, geo: geo)
                        .frame(width: geo.size.width)
                        
                        .padding(.vertical, 8)
                    }
                    if isLoading {
                        ProgressView(value: loadingProgress, total: 100)
                    }
                    ControlBar
                }
                .clipped()
                
                
            }
            
        }
        .background {
            Color.white
        }
        
    }
}



struct OpenAIMessageView: View {
    @State var message: OpenAIConversationMessage? = nil
    @State var roleColor: Color = .black
    var geo: GeometryProxy? = nil
    var body: some View {
        HStack {
            if let message = message, let geo = geo  {
                VStack {
                    Text(message.roleString)
                        .foregroundColor(roleColor)
                        .frame(width: geo.size.width * 0.2, alignment: .trailing)
                    Spacer()
                }
                Text(message.content)
                Spacer()
            }
            
        }
    }
}

struct OpenAIConversationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OpenAIConversationView(messages: .constant([
                OpenAIConversationMessage.mockMessages,
                [OpenAIConversationMessage.conversationOverMessage],
            ].flatMap({$0})))
            .frame(height: 320)
            
        }
        .background {
            Color.darkBlue
                .ignoresSafeArea()
        }
    }
    
}
