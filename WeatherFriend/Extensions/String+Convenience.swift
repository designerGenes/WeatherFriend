import Foundation

extension String {
    func queryItem(_ val: String?) -> URLQueryItem {
        return URLQueryItem(name: self, value: val)
    }
    
    
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return rhs.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
}
