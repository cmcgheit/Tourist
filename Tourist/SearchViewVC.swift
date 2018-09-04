//SearchViewVC.swift, coded with love by C McGhee

import Foundation
import UIKit
import Pulley

class SearchViewVC: UIViewController {
    
    var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideStatusBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showStatusBar()
    }
    
    @IBAction func goBackButtonPressed(sender: AnyObject) {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
        
        self.pulleyViewController?.setPrimaryContentViewController(controller: mapVC, animated: true)
    }
    
    // MARK: - Status Bar Animation Functions
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func hideStatusBar() {
        isStatusBarHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func showStatusBar() {
        isStatusBarHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
}



