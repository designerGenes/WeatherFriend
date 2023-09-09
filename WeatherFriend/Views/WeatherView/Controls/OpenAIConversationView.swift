import UIKit
import SwiftUI

protocol OpenAIConversationViewDelegate {
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async
}

protocol OpenAIConversationViewType {
    var loadingProgress: Double { get set }
}

struct OpenAIConversationView: View, OpenAIConversationViewType {
    @State var delegate: OpenAIConversationViewDelegate?
    @Binding var isShowingConversationCommands: Bool
    @Binding var loadingProgress: Double
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
            
            .padding()
            
        }
        .background {
            Color(uiColor: .primaryBackgroundColor)
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
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)
                            .padding(.vertical, 8)
                    }
                    if isShowingConversationCommands {
                        ControlBar
                    }
                }
                .clipped()
            }
            
        }
        .background {
            Color(uiColor: .primaryBackgroundColor)
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
                    .foregroundStyle(Color(uiColor: .primaryTextColor))
                Spacer()
            }
            
        }
    }
}

struct OpenAIConversationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OpenAIConversationView(
                isShowingConversationCommands: .constant(true),
                loadingProgress: .constant(0.4),
                messages: .constant([
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
