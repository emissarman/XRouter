//
//  StringMatcher
//  XRouter
//

import Foundation

/**
 - Note: Strings are compared case insensitiveely
 */
public enum StringMatcher {
    
    /// Matches any string
    case any
    
    /// Matches a single string
    case one(String)
    
    /// Matches many strings
    case many([String])
    
    /// Does this string match
    public func matches(_ input: String?) -> Bool {
        switch self {
        case .any:
            return true
            
        case let .one(value):
            guard let input = input else { return false }
            return value.caseInsensitiveCompare(input) == .orderedSame
            
        case let .many(values):
            guard let input = input else { return false }
            return values.contains(where: { return $0.caseInsensitiveCompare(input) == .orderedSame})
        }
    }

}
