//
//  Tab1ViewController.swift
//  XRouter_Example
//

import UIKit

/**
 Tab 1 View Controller
 */
class Tab1ViewController: UIViewController {
    
    /// Coordinator
    weak var coordinator: Tab1Coordinator!

    /// Tapped button 1
    @IBAction func tappedButton1(_ sender: Any) {
        coordinator.gotoProfile(withID: "Amy")
    }
    
    /// Tapped button 2
    @IBAction func tappedButton2(_ sender: Any) {
        coordinator.gotoProfile(withID: "Bruce")
    }
    
    /// Tapped button 3
    @IBAction func tappedButton3(_ sender: Any) {
        coordinator.gotoProfile(withID: "Cameron")
    }
    
}
