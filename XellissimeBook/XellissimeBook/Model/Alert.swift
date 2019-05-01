//
//  Alert.swift
//  XellissimeBook
//
//  Created by ALEXANDRE GROSSON on 01/05/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Class Alert
/**
 This class enables presentation of an alert what ever the viewController
 */
class Alert{
    // MARK: - Properties
    /// ViewController on which the alert will be displayed (self)
    var controller: UIViewController?
    /// Variable that tracks the case of alert
    var alertDisplay :  AlertCase = .emailBadlyFormatted {
        didSet {
            presentAlert(alertCase: alertDisplay)
        }
    }
    /// Singleton Object
    static var shared = Alert()
    // MARK: - Enum
    /// Enum that lists all cases of alert presentations
    enum AlertCase {
        case userEmailAlreadyUsedByAnotherUser, emailBadlyFormatted, passwordIsTooShort, noData, noUserRegistered, invalidPassword
    }
    // MARK: -
    init() {}
    // MARK: - Methods
    /**
     Function that presents an alert with defined text depending on AlertCase
     - Parameter myCase: variable used to set text of the alert
     */
    
    private func presentAlert(alertCase: AlertCase){
        switch alertCase {
        case .userEmailAlreadyUsedByAnotherUser:
            controller?.presentAlertDetails(title: "Sorry",
                                            message: TextAndString.shared.userEmailAlreadyUsedByAnotherUser,
                                            titleButton: "OK")
        case .emailBadlyFormatted :
            controller?.presentAlertDetails(title: "Sorry",
                                            message: TextAndString.shared.emailBadlyFormatted,
                                            titleButton: "OK")
        case .passwordIsTooShort:
            controller?.presentAlertDetails(title: "Sorry",
                                            message: TextAndString.shared.passwordIsTooShort,
                                            titleButton: "OK")
        case .noData:
            controller?.presentAlertDetails(title: "Sorry",
                                            message: TextAndString.shared.noData,
                                            titleButton: "OK")
        case .noUserRegistered:
            controller?.presentAlertDetails(title: "Sorry",
            message: TextAndString.shared.noUserRegistered,
            titleButton: "OK")
        case .invalidPassword:
            controller?.presentAlertDetails(title: "Sorry",
                                            message: TextAndString.shared.invalidPassword,
                                            titleButton: "OK")            
        }
    }
}
// MARK: - Extension
extension UIViewController {
    /**
     Function that presents an alert
     */
    func presentAlertDetails(title: String, message: String, titleButton: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: titleButton, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
