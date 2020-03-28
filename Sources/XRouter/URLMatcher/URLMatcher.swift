//
//  Router+URLMatcher
//  XRouter
//

import Foundation

/**
 Represents a list of URL mappings for a set of paths on some host(s)/scheme(s).
 */
public class URLMatcher<Route: RouteType> {
    
    // MARK: - Properties
    
    /// Only matches against these hosts.
    internal let hosts: StringMatcher
    
    /// Only matches against these schemes.
    internal let schemes: StringMatcher
    
    /// Path mapper
    internal let pathMapper: URLPathMapper<Route>
    
    // MARK: - Methods
    
    /// Match some host
    public static func host(_ host: String, _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcher {
        return .init(hosts: .one(host), schemes: .any, mapPathsClosure)
    }
    
    /// Match some scheme
    public static func scheme(_ scheme: String, _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcher {
        return .init(hosts: .any, schemes: .one(scheme), mapPathsClosure)
    }
    
    /// Set a group of mapped paths for some hosts/schemes.
    public static func group(hosts: StringMatcher = .any,
                             schemes: StringMatcher = .any,
                             _ mapPathsClosure: (URLPathMapper<Route>) -> Void) -> URLMatcher {
        return .init(hosts: hosts, schemes: schemes, mapPathsClosure)
    }
    
    // MARK: - Implementation
    
    /// Init
    internal init(hosts: StringMatcher, schemes: StringMatcher, _ mapPathsClosure: (URLPathMapper<Route>) -> Void) {
        self.hosts = hosts
        self.schemes = schemes
        self.pathMapper = URLPathMapper()
        
        // Run the path matching
        mapPathsClosure(pathMapper)
    }
    
    /// Match a URL to one of the paths for host/scheme.
    internal func match(url: URL) throws -> Route? {
        guard hosts.matches(url.host),
            schemes.matches(url.scheme) else {
                return nil
        }
        
        return try pathMapper.match(url)
    }
    
}
