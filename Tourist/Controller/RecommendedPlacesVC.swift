//RecommendedPlacesVC.swift, created with love by C McGhee

import UIKit
import Cards
import GooglePlaces

class RecommendedPlacesVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bringDownBackButton()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    // override func viewDidDisappear(_ animated: Bool) {
    // super.viewDidDisappear(animated)
    // Show navi bar on all pages but MainVC
    // navigationController?.setNavigationBarHidden(false, animated: true)
    
    func bringDownBackButton() {
        navigationController?.navigationBar.layer.frame.origin.y = 22
    }
    
    // MARK: - Status Bar Animation Functions
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
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

extension RecommendedPlacesVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table View Functions to Photo Card
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath)
        let cardH = cell.viewWithTag(1) as! CardHighlight
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardsContentVC")
        cardH.shouldPresent(cardContent, from: self, fullscreen: true)
        // cell.configurePhotoCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
