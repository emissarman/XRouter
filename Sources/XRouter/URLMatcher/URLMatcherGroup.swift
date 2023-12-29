//
//  Router+URLMatcherGroup
//  XRouter
//

import Foundation

/**
 Maintains a list of URLMatchers, and some shortcuts to create groups.
 */
public struct URLMatcherGroup<Route: RouteType> {
    
    // MARK: - Properties
    
    /// URL matchers
    public let matchers: [URLMatcher<Route>]!
    
    public init(matchers: [URLMatcher<Route>]) {
        self.matchers = matchers
    }
    
    // MARK: - Helper methods
    
    /// Match some host.
    public static func host(_ host: String, _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcherGroup<Route> {
        return .group(hosts: .one(host), mapPathsClosure)
    }
    
    /// Match some scheme.
    public static func scheme(_ scheme: String, _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcherGroup<Route> {
        return .group(schemes: .one(scheme), mapPathsClosure)
    }
    
    /// Set a group of mapped paths for multiple hosts
    public static func group(hosts: StringMatcher = .any,
                             schemes: StringMatcher = .any,
                             _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcherGroup<Route> {
        return .init(matchers: [URLMatcher(hosts: hosts, schemes: schemes, mapPathsClosure)])
    }
    
    // MARK: - Methods
    
    /// Find  matching URL
    internal func findMatch(forURL url: URL) throws -> Route? {
        for urlMatcher in matchers {
            if let route = try urlMatcher.match(url: url) {
                return route
            }
        }
        
        return nil
    }
    
}
