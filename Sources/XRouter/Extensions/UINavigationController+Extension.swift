//
//  UINavigationController+Extension
//  XRouter
//

#if canImport(UIKit)

import UIKit

/**
 Variants of push/set navigation with a completion closure.
 
 Source: https://stackoverflow.com/a/33767837
 Author: https://stackoverflow.com/users/312594/par
 */
internal extension UINavigationController {
    
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async {
                completion()
            }
            
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
    
    func setViewControllers(
        _ viewControllers: [UIViewController],
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        setViewControllers(viewControllers, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
    
}

#endif
