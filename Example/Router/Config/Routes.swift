//
//  Routes.swift
//  XRouter_Example
//

import XRouter

/**
 Example Routes
 */
enum Route: RouteProvider {
    
    case tab1Home
    
    case tab2Home
    
    case pushedVC
    
    case modalVC
    
    /// Transitions for the view controllers
    var transition: RouteTransition {
        switch self {
        case .tab1Home,
             .tab2Home:
            return .set
        case .pushedVC:
            return .push
        case .modalVC:
            return .modal
        }
    }
    
    /// Prepare the route for transition and return the view controller
    ///  to transition to on the view hierachy
    func prepareForTransition(from viewController: UIViewController) throws -> UIViewController {
        switch self {
        case .tab1Home:
            return container.tab1Coordinator.gotoTabHome()
        case .tab2Home:
            return container.tab2Coordinator.navigationController.viewControllers[0]
        case .pushedVC:
            return container.tab2SecondViewController
        case .modalVC:
            return container.modalCoordinator.start()
        }
    }
    
}
