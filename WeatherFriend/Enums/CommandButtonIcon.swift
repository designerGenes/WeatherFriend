import Foundation

enum CommandButtonIcon: String {
    case cloud_drizzle_fill = "cloud.drizzle.fill"
//    case chart_bar_xaxis = "chart.bar.xaxis"
    case gear_shape_fill = "gearshape.fill"
    
    var matchingScreen: Screen {
        switch self {
        case .cloud_drizzle_fill:
            return .main
//        case .chart_bar_xaxis:
//            return .charts
        case .gear_shape_fill:
            return .settings
        }
    }
    
    static var allCases: [CommandButtonIcon] {
        return [.cloud_drizzle_fill/*, .chart_bar_xaxis*/, .gear_shape_fill]
    }
}

