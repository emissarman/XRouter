//
//  XRouter.swift
//  XRouter
//
//  Created by Reece Como on 5/1/19.
//

import UIKit

/**
 An appliance that analyzes the navigation stack, and navigates you to the content you are trying to display.
 
 ```swift
 // Define your router, with a `RouteProvider`
 let router = Router<AppRoutes>()
 ```
 */
open class Router<Route: RouteProvider> {
    
    // MARK: - Properties
    
    /// Custom transition delegate
    public weak var customTransitionDelegate: RouterCustomTransitionDelegate?
    
    /// Register url matcher group
    private lazy var urlMatcherGroup: URLMatcherGroup? = Route.registerURLs()
    
    // MARK: - Computed properties
    
    /// The navigation controller for the currently presented view controller
    public var currentTopViewController: UIViewController? {
        return UIApplication.shared.getTopViewController()
    }
    
    // MARK: - Methods
    
    /// Initialiser
    public init() {
        // Placeholder, required to expose `init` as `public`
    }
    
    ///
    /// Navigate to a route.
    ///
    /// - Note: Has no effect if the destination view controller is the view controller or navigation controller
    ///         you are presently on - as provided by `RouteProvider(_:).prepareForTransition(...)`.
    ///
    open func navigate(to route: Route, animated: Bool = true, completion: ((Error?) -> Void)? = nil) {
        prepareForNavigation(to: route, animated: animated, successHandler: { viewController in
            self.performNavigation(to: viewController,
                                   with: route.transition,
                                   animated: animated,
                                   completion: completion)
        }, errorHandler: { error in
            completion?(error)
        })
    }
    
    ///
    /// Open a URL to a route.
    ///
    /// - Note: Register your URL mappings in your `RouteProvider` by
    ///         implementing the static method `registerURLs`.
    ///
    @discardableResult
    open func openURL(_ url: URL, animated: Bool = true, completion: ((Error?) -> Void)? = nil) -> Bool {
        do {
            if let route = try findMatchingRoute(for: url) {
                navigate(to: route, animated: animated, completion: completion)
                return true
            } else {
                completion?(nil) // No matching route.
            }
        } catch {
            completion?(error) // There was an error.
        }
        
        return false
    }
    
    // MARK: - Implementation
    
    ///
    /// Prepare the route for navigation by:
    ///     - Fetching the view controller we want to present
    ///     - Checking if its already in the view heirarchy
    ///         - Checking if it is a direct ancestor and then closing its children/siblings
    ///
    /// - Note: The completion block will not execute if we could not find a route
    ///
    private func prepareForNavigation(to route: Route,
                                      animated: Bool,
                                      successHandler: @escaping (UIViewController) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        guard let currentViewController = currentTopViewController else {
            errorHandler(RouterError.missingSourceViewController)
            return
        }
        
        /// Get destination view controller
        let newViewController: UIViewController
        do {
            newViewController = try route.prepareForTransition(from: currentViewController)
        } catch {
            errorHandler(error)
            return
        }
        
        if newViewController === currentViewController.navigationController
            || newViewController === currentViewController {
            // We're already presenting this view controller (or its navigation controller).
            successHandler(newViewController)
        } else if newViewController.isActive() {
            // Trying to route to a view controller that is already presented somewhere
            //   in an existing navigation stack.
            
            guard currentViewController.hasAncestor(newViewController) else {
                // If this is not an ancestor of the current view controller, then we won't
                //  be able to automatically find a route.
                errorHandler(RouterError.unableToFindRouteToViewController)
                return
            }
            
            if let currentNavController = currentViewController.navigationController,
                !currentNavController.isBeingPresented,
                currentNavController == newViewController.navigationController {
                successHandler(newViewController)
            } else {
                // In the meantime let's attempt to find a route by dismissing any modals.
                newViewController.dismiss(animated: animated) {
                    successHandler(newViewController)
                }
            }
        } else {
            successHandler(newViewController)
        }
    }
    
    /// Perform navigation
    private func performNavigation(to destinationViewController: UIViewController,
                                   with transition: RouteTransition,
                                   animated: Bool,
                                   completion: ((Error?) -> Void)?) {
        // Sanity check, make sure we're coming from somewhere.
        guard var sourceViewController = currentTopViewController else {
            completion?(RouterError.missingSourceViewController)
            return
        }
        
        // Sanity check, don't navigate if we're already here,
        //  or we're trying to set THIS view controller's navigation controller
        if destinationViewController === sourceViewController
            || destinationViewController === sourceViewController.navigationController {
            // No error? -- maybe throw an "already here" error
            completion?(nil)
            return
        }
        
        // The source view controller will be the navigation controller where
        //  possible - but will otherwise default to the current view controller
        //  i.e. for "present" transitions.
        sourceViewController = sourceViewController.navigationController ?? sourceViewController
        
        switch transition {
        case .push:
            if let navController = sourceViewController as? UINavigationController {
                navController.pushViewController(destinationViewController, animated: animated) {
                    completion?(nil)
                }
            } else {
                completion?(RouterError.missingRequiredNavigationController(for: transition))
            }
            
            
        case .set:
            if let navController = sourceViewController as? UINavigationController {
                navController.setViewControllers([destinationViewController], animated: animated) {
                    completion?(nil)
                }
            } else {
                completion?(RouterError.missingRequiredNavigationController(for: transition))
            }
            
        case .modal:
            sourceViewController.present(destinationViewController, animated: animated) {
                completion?(nil)
            }
            
        case .custom:
            if let customTransitionDelegate = customTransitionDelegate {
                customTransitionDelegate.performTransition(to: destinationViewController,
                                                           from: sourceViewController,
                                                           transition: transition,
                                                           animated: animated,
                                                           completion: completion)
            } else {
                completion?(RouterError.missingCustomTransitionDelegate)
            }
        }
    }
    
    ///
    /// Find a matching Route for a URL.
    ///
    /// - Note: This method throws an error when the route is mapped
    ///         but the mapping fails.
    ///
    private func findMatchingRoute(for url: URL) throws -> Route? {
        if let urlMatcherGroup = urlMatcherGroup {
            for urlMatcher in urlMatcherGroup.matchers {
                if let route = try urlMatcher.match(url: url) {
                    return route
                }
            }
        }
        
        return nil
    }
    
}
