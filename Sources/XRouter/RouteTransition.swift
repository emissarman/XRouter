//
//  RouteTransition
//  XRouter
//

#if canImport(UIKit)

import UIKit

/// Transition closure.
public typealias TransitionClosure = (_ from: UIViewController,
                                      _ to: UIViewController,
                                      _ animated: Bool,
                                      _ completion: @escaping (Error?) -> Void) -> Void

/**
 The types of presentation transitions for Routes.

 ```swift
 let myTransition = RouteTransition { (source, destination, animated, completion) in
     source.present
 }
 ```
 */
public class RouteTransition {
  
    /// Transition storage
    let performTransition: TransitionClosure

    /// Constructor.
    public init(_ transition: @escaping TransitionClosure) {
        self.performTransition = transition
    }

}

/**
 Built-in Transitions
 */
public extension RouteTransition {

    // MARK: - Built-in Transitions

    ///
    /// Automatically infer an appropriate transition from the current context.
    ///
    static let automatic = RouteTransition { (source, destination, animated, completion) in
        inferTransition(from: source, to: destination)
            .performTransition(source, destination, animated, completion)
    }

    ///
    /// Uses `UIViewController(_:).present(_:animated:completion:)`.
    ///
    /// - See: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-presentviewcontroller
    ///
    static let modal = RouteTransition { (source, destination, animated, completion) in
        source.present(destination, animated: animated) {
            completion(nil)
        }
    }

    ///
    /// Uses `UINavigationController(_:).pushViewController(_:animated:)`if the destination view controller is not already
    /// in the navigation hierachy, otherwise it will use `UINavigationController(_:).setViewControllers(to:animated:)`.
    ///
    /// Push the view controller (or pop to it if it is already in the stack).
    ///
    /// - Note: This transition can *only* be used when you are navigating from a `UINavigationController`.
    ///
    /// - See: https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621887-pushviewcontroller?language=objc
    ///
    static let push = RouteTransition { (source, destination, animated, completion) in
        guard let navController = source as? UINavigationController else {
            completion(RouterError.missingRequiredNavigationController)
            return
        }

        if let index = navController.viewControllers.firstIndex(of: destination) {
            // If already in the stack, dismiss any view controllers that are on top.
            navController.setViewControllers(Array(navController.viewControllers[...index]), animated: animated) {
                completion(nil)
            }
        } else {
            // Otherwise push the new view controller.
            navController.pushViewController(destination, animated: animated) {
                completion(nil)
            }
        }
    }

    ///
    /// Clear the stack and replace it with the destination view controller.
    ///
    /// Uses `UINavigationController(_:).setViewControllers(to:animated:)`.
    ///
    /// - Note: This transition can *only* be used when you are navigating from a `UINavigationController`.
    ///
    /// If the view controller is currently in the stack, but is not the topmost item, this method uses a pop transition; if it is the topmost item, no transition is performed. If the view controller is not on the stack, this method uses a push transition.
    /// - See: https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621861-setviewcontrollers
    ///
    static let replace = RouteTransition { (source, destination, animated, completion) in
        guard let navController = source as? UINavigationController else {
            completion(RouterError.missingRequiredNavigationController)
            return
        }
        
        navController.setViewControllers([destination], animated: animated) {
            completion(nil)
        }
    }
    
    // MARK: - Implementation
    
    /// Infer the best transition to use for two view controllers in the view hierachy.
    private static func inferTransition(from source: UIViewController,
                                        to destination: UIViewController) -> RouteTransition {
        // We need to use a modal if we don't have a nav controller or we're moving to a new one.
        if !(source is UINavigationController) || destination is UINavigationController {
            return modal
        }
        
        return push
    }

}

/**
 Equatable
 */
extension RouteTransition: Equatable {
    
    /// Uses identity for equality check.
    public static func == (lhs: RouteTransition, rhs: RouteTransition) -> Bool {
        return lhs === rhs
    }
    
}

#endif
