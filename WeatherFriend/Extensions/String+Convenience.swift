import Foundation

extension String {
    func queryItem(_ val: String?) -> URLQueryItem {
        return URLQueryItem(name: self, value: val)
    }
}
