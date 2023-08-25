import UIKit
import SwiftUI

class WeatherAdviceViewModel: ObservableObject, WeatherAdviceViewModelType {
    @Published var weatherAdvice: WeatherAdviceType?
    var titleText: String = "Your AI Weather Advice "
    
    func submitCommand(command: OpenAICommand) {
        // Implement your logic here
    }
}

protocol WeatherAdviceViewModelType: ObservableObject {
    var weatherAdvice: WeatherAdviceType? { get }
    var titleText: String { get }
    func submitCommand(command: OpenAICommand)
}

struct OpenAIControlView<ViewModel: WeatherAdviceViewModelType>: View {
    var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Group {
                Text("Yes")
                    .onTapGesture {
                        viewModel.submitCommand(command: .yes)
                    }
                Text("No")
                    .onTapGesture {
                        viewModel.submitCommand(command: .no)
                    }
                Text("Retry")
                    .onTapGesture {
                        viewModel.submitCommand(command: .retry)
                    }
            }
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
        }
    }
}


struct WeatherAdviceView<ViewModel: WeatherAdviceViewModelType>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.lighterDarkBlue
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    ScrollView {
                        Group {
                            Text(viewModel.titleText)
                            Text(viewModel.weatherAdvice?.advice ?? "...")
                        }
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 4))
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.8))
                        .frame(width: geo.size.width, alignment: .leading)
                        
                        Spacer()
                        
                        OpenAIControlView(viewModel: self.viewModel)
                            .padding()
                    }
                }
            }
        }
        .cornerRadius(8)
    }
}

//#Preview {
//    VStack {
//        
//    }
//}
