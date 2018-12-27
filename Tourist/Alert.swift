//Alert.swift, coded with love by C McGhee

import Foundation
import UIKit

public class Alert: NSObject {
    class func presentDefaultAlert(delegate: UIViewController, message: String) {
        let defaultAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        defaultAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        delegate.present(defaultAlert, animated: true, completion: nil)
    }
    
    class func presentDefaultErrorMsg(delegate: UIViewController, message: String) {
        let defautErrorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        defautErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        delegate.present(defautErrorAlert, animated: true, completion: nil)
    }
    
    class func presentLocationAlert(delegate: UIViewController, message: String) {
        let locationAlert = UIAlertController(title: "Location Accces Denied", message: message, preferredStyle: UIAlertController.Style.alert)
        locationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        delegate.present(locationAlert, animated: true, completion: nil)
    }
    
}
