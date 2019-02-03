//
//  ModalViewController.swift
//  XRouter_Example
//

import UIKit

/**
 Pushed View Controller
 */
class ModalViewController: UIViewController {
    
    /// Coordinator
    weak var coordinator: ModalCoordinator!
    
    /// Tapped close
    @IBAction func tappedCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Tapped push view controller
    @IBAction func tappedPushViewController(_ sender: Any) {
        coordinator.gotoSecondPage()
    }
    
}
