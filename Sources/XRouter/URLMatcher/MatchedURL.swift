//
//  MatchedURL
//  XRouter
//

import Foundation

/**
 Represents a URL that has been matched to a registered route.
 
 Provides parameter mapping shortcuts.
 
 - Note: For use when handling routing parameters.
 - See: `RouteType.registerURLs(...)`
 
 Usage:
 ```swift
 // Path components
 let name: String = try $0.path("name")
 let pageId: Int = try $0.path("id")
 
 // Query string parameters
 let all: [String: String] = $0.queryParameters
 let offset: String? = $0.query("offset")
 let page = $0.query("page") ?? 0
 
 // URL Host/Scheme
 let host: String? = $0.host
 let scheme: String? = $0.scheme
 ```
 */
public class MatchedURL {
    
    /// Associated URL
    public let rawURL: URL
    
    /// Query string parameter shortcuts
    public lazy var queryParameters: [String: String] = {
        var queryItems = [String: String]()
        
        if let parts = URLComponents(url: rawURL, resolvingAgainstBaseURL: false),
            let queryParts = parts.queryItems {
            for queryPart in queryParts {
                if let value = queryPart.value {
                    queryItems[queryPart.name] = value
                }
            }
        }
        
        return queryItems
    }()
    
    /// Get the scheme (e.g. "https")
    public lazy var scheme: String? = rawURL.scheme
    
    /// Get the host (e.g. "example.com")
    public lazy var host: String? = rawURL.host
    
    /// Path parameters storage
    private let pathParameters: [String: String]
    
    /// Initialiser
    internal init(for url: URL, pathParameters: [String: String]) {
        self.rawURL = url
        self.pathParameters = pathParameters
    }
    
    // MARK: - Methods
    
    /// Retrieve a path parameter as a `String`
    public func path(_ name: String) throws -> String {
        if let pathParameter = pathParameters[name] {
            return pathParameter
        }
        
        throw RouterError.missingRequiredPathParameter(parameter: name)
    }
    
    /// Retrieve a path parameter as an `Int`
    public func path(_ name: String) throws -> Int {
        let stringParameter: String = try path(name)
        
        if let intParameter = Int(stringParameter) {
            return intParameter
        }
        
        throw RouterError.requiredIntegerParameterWasNotAnInteger(parameter: name, stringValue: stringParameter)
    }
    
    /// Retrieve a query string parameter as a `String`
    public func query(_ name: String) -> String? {
        return queryParameters[name]
    }
    
    /// Retrieve a query string parameter as an `Int`
    public func query(_ name: String) -> Int? {
        if let queryItem = queryParameters[name] {
            return Int(queryItem)
        }
        
        return nil
    }
    
}
