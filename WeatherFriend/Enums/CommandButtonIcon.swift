import Foundation

enum CommandButtonIcon: String {
    case sparkles, cloud, hurricane, sunrise
    case moon_stars_circle_fill = "moon.stars.circle.fill"
    case cloud_drizzle_fill = "cloud.drizzle.fill"
    static var allCases: [CommandButtonIcon] {
        [.sparkles, .cloud, .hurricane, .sunrise, .moon_stars_circle_fill, .cloud_drizzle_fill]
    }
}

