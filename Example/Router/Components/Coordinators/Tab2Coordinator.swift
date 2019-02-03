//
//  Tab2Coordinator.swift
//

import UIKit

/**
 Tab 2 Coordinator
 
 An example coordinator for a navigation tab.
 */
class Tab2Coordinator {
    
    // MARK: - Navigation
    
    /// Navigation controller
    private(set) lazy var navigationController = UINavigationController(rootViewController: rootViewController)
    
    /// Root view controller
    private lazy var rootViewController: UIViewController = container.tab2ViewController
    
}
