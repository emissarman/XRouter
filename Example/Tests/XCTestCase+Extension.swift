//
//  XCTestCase+Extension.swift
//  XRouter_Tests
//
//  Created by Reece Como on 16/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import XRouter

extension XCTestCase {
    
    typealias ErrorHandler = (Error?) -> Void
    
    /// Closure takes in an error handler, which you need to pass
    func assertErrorHandlerIsTriggered(error expectedError: RouterError,
                                       timeout: UInt32 = 3,
                                       _ closure: @escaping (ErrorHandler?) -> Void) {
        DispatchQueue.global().async {
            var hasTriggeredErrorHandler = false
            var timeoutRemaining = timeout
            
            let errorHandler = { (actualError: Error?) in
                hasTriggeredErrorHandler = true
                
                guard let actualError = actualError else {
                    XCTFail("Did not receive an error")
                    return
                }
                
                // Eh... Check the error messages are the same.
                XCTAssertEqual(expectedError.localizedDescription, (actualError as? RouterError)?.localizedDescription)
            }
            
            while !hasTriggeredErrorHandler, timeoutRemaining > 0 {
                DispatchQueue.main.async {
                    closure(errorHandler)
                }
                
                sleep(1)
                timeoutRemaining -= 1
            }
            
            XCTFail("Expected error was not triggered before timeout.")
        }
    }

}


