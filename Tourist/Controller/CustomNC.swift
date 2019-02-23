// CustomNC.swift, coded with love by C McGhee

import UIKit

class CustomNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNaviBarInvisible()

    }
    
    func makeNaviBarInvisible() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
