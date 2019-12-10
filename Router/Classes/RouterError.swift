//
//  RouterError
//  XRouter
//

import Foundation

/**
 Errors that can be thrown by Router.
 */
public enum RouterError {
    
    // MARK: - Errors
    
    /// The route transition can only be called from a UINavigationController
    case missingRequiredNavigationController
    
    /// Missing required parameter while unwrapping URL route
    case missingRequiredPathParameter(parameter: String)
    
    /// There is currently no top view controller on the navigation stack
    /// - Note: This really won't ever occur, unless you are doing something super bizarre with the `UIWindow(_:).rootViewController`.
    case missingSourceViewController
    
    /// A required parameter was found, but it was not an Int
    case requiredIntegerParameterWasNotAnInteger(parameter: String, stringValue: String)
    
    /// No view controller has been configured
    case destinationHasNotBeenConfigured
    
}

extension RouterError: LocalizedError {
    
    // MARK: - LocalizedError
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .missingRequiredNavigationController:
            return """
            Attempted to navigate to a route, but the source view controller was not a navigation controller.
            """
        case let .missingRequiredPathParameter(name):
            return """
            Missing required path parameter \"\(name)\" while unwrapping URL route.
            """
        case .missingSourceViewController:
            return """
            The source view controller (AKA current top view controller) was unexpectedly `nil`.
            This could be because the top view controller is an empty navigation controller, or
            if the window, or window's root view controller is `nil`.
            """
        case let .requiredIntegerParameterWasNotAnInteger(name, stringValue):
            return """
            Required integer parameter \"\(name)\" existed, but was not an integer.
            Instead \"\(stringValue)\" was received."
            """
        case .destinationHasNotBeenConfigured:
            return """
            Attempted to navigate to a route, but no route was configured.
            """
        }
    }
    
    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        switch self {
        case .missingRequiredNavigationController:
            return """
            Nest the parent view controller in a `UINavigationController`.
            """
        case let .missingRequiredPathParameter(name):
            return """
            You referenced a parameter \"\(name)\" that wasn't declared in the `PathPattern`.
            Please include the parameter in `PathPattern`, or remove it from the mapping.
            """
        case .missingSourceViewController:
            return """
            Something unexpected has happened and the source view controller was not able to be located.
            """
        case let .requiredIntegerParameterWasNotAnInteger(_, stringValue):
            return """
            The value that was received was \"\(stringValue)\", which could not be cast to `Int`.
            """
        case .destinationHasNotBeenConfigured:
            return """
            Configure view controllers for your routes by overriding `prepareForNavigation(to:)` in your Router,
            or by implementing a `RoutingHandler`.
            """
        }
    }
    
    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return errorDescription
    }
    
    /// A localized message providing "help" text if the user requests help.
    public var helpAnchor: String? {
        return nil // Not implemented
    }
    
}
