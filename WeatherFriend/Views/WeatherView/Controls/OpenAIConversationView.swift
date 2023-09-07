import UIKit
import SwiftUI




struct OpenAIConversationView: View {
    @State var rolesToHide: [OpenAIRole] = [.system]
    @State var roleColors: [OpenAIRole : Color] = [
        .assistant: Color.blue,
        .user: .lightOrange,
        .system: .clear
    ]
    @Binding var messages: [OpenAIConversationMessage]
    
    var filteredMessages: [OpenAIConversationMessage] {
        messages.filter({ message in rolesToHide.filter({$0 == message.role}).isEmpty })
    }
    
    
    var ControlBar: some View {
        HStack {
            Spacer()
            Group {
                TintChangingButton(iconImage: Image(systemName: "checkmark.circle"), title: OpenAICommand.yes.rawValue.uppercased()) {
                    
                }
                TintChangingButton(iconImage: Image(systemName: "x.circle"), title: OpenAICommand.no.rawValue.uppercased()) {
                    
                }
                TintChangingButton(iconImage: Image(systemName: "ellipsis.bubble.fill"), title: OpenAICommand.retry.rawValue.uppercased()) {
                    
                }
            }
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            
        }
        .background {
            Color.darkBlue
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(filteredMessages) { message in
                        HStack {
                            VStack {
                                Text(message.roleString)
                                    .foregroundColor(roleColors[message.role])
                                    .frame(width: geo.size.width * 0.2, alignment: .trailing)
                                Spacer()
                            }
                            Text(message.content)
                            Spacer()
                        }
                        .frame(width: geo.size.width)
                        
                        .padding(.vertical, 8)
                    }
                }
                .clipped()
                
                ControlBar
            }
            
        }
        .background {
            Color.white
        }
        
    }
}

struct OpenAIConversationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OpenAIConversationView(messages: .constant(OpenAIConversationMessage.mockMessages))
            .frame(height: 320)
        }
        .background {
            Color.darkBlue
                .ignoresSafeArea()
        }
    }
    
}
