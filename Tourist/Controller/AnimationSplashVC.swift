//AnimationSplashVC.swift, coded with love by C McGhee

import UIKit

class AnimationSplashVC: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var splashView: UIView!
    
    var splashTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fadeAnimation()
        
        splashTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(AnimationSplashVC.goToMapVC), userInfo: nil, repeats: false)
        
    }
    
    @objc func goToMapVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mapVC = storyboard.instantiateViewController(withIdentifier: "MapsContainerVC") as? MapsContainerVC else { return }
        self.present(mapVC, animated: true, completion: nil)
        self.splashTimer.invalidate()
    }
    
    func fadeAnimation() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.splashView.alpha = 0.0
            self.logoImage.alpha = 0.0
        }).startAnimation()
    }

}
