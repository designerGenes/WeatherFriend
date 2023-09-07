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
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages.filter({ message in rolesToHide.filter({$0 == message.role}).isEmpty })) { message in
                        HStack {
                            VStack {
                                Text(message.roleString)
                                    .foregroundColor(roleColors[message.role])
                                .frame(width: geo.size.width * 0.2, alignment: .leading)
                                Spacer()
                            }
                            
                            
                            Text(message.content)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
        }
        .background {
            Color.white
        }
        
    }
}

struct OpenAIConversationView_Preivews: PreviewProvider {
    static var previews: some View {
        VStack {
            OpenAIConversationView(messages: .constant([
                OpenAIConversationMessage(content: "You are an AI assistant who is a fusion chef with expertise in molecular gastronomy and astrology.", role: .system),
                OpenAIConversationMessage(content: "Welcome! I'm your personal fusion chef and astrologer. Whether you're looking for a recipe to impress or insight into your zodiac sign, I've got you covered. What's on your mind today?", role: .assistant),
                OpenAIConversationMessage(content: "What's the best dish for a Cancer?", role: .user),
                OpenAIConversationMessage(content: "Cancers are known for their love of comfort and home. I'd recommend a Lobster Mac and Cheese with a truffle-infused béchamel sauce. It combines the cozy feel of a home-cooked meal with a touch of gourmet flair.", role: .assistant),
                OpenAIConversationMessage(content: "Astrologically speaking, the position of the planets can influence your mood and intuition, which indirectly affects your culinary creativity. For instance, Venus in Taurus might make you gravitate towards richer, more luxurious ingredients.", role: .assistant),
                OpenAIConversationMessage(content: "Can molecular gastronomy improve a comfort dish?", role: .user),
                OpenAIConversationMessage(content: "Absolutely, molecular gastronomy can elevate comfort food to a new level. Imagine a classic grilled cheese sandwich, but with a tomato soup \"caviar\" that bursts in your mouth. The familiar flavors remain, but the experience becomes more interactive and memorable.", role: .assistant),
                OpenAIConversationMessage(content: "What's your star sign, assistant?", role: .user),
                OpenAIConversationMessage(content: "As a machine, I don't have a star sign, but if I were to choose one based on my programming, I'd be a Libra—always striving for balance, especially between flavors and cosmic energies.", role: .assistant),
            ]))
        }
    }
}
