//RecommendedPlacesVC.swift, created with love by C McGhee

import UIKit
import Cards

class RecommendedPlacesVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuSideBarBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var backgroundCoverBtn: UIButton!
    @IBOutlet weak var menuCurveImageView: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        menuCurveImageView.image = #imageLiteral(resourceName: "MenuCurve")
    }
    
    @IBAction func menutapped( _ sender: UIButton) {
        if (menuShowing) {
        menuViewLeadingConstraint.constant = -96
        } else {
            showMenu()
            menuViewLeadingConstraint.constant = 0
        }
        menuShowing = !menuShowing
    }
    
    @IBAction func backgroundTapped(_ sender: UIButton) {
        hideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove navi bar from all screens
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // override func viewDidDisappear(_ animated: Bool) {
    // super.viewDidDisappear(animated)
    // Show navi bar on all pages but MainVC
    // navigationController?.setNavigationBarHidden(false, animated: true)
    
    // MARK: - Side Menu Functions
    func showMenu() {
        UIView.animate(withDuration: 0.4, animations:  {
            self.menuView.alpha = 1
            self.backgroundCoverBtn.alpha = 1
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            // Animate all buttons on side menu bar, when add more menu buttons, add a new UIView.animate section and change delay
            self.profileBtn.transform = .identity
            self.mapBtn.transform = .identity
            self.searchBtn.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = .identity
        })
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.4, animations:  {
            self.menuView.alpha = 0 //Remove if more than 3 button items for effect
            self.backgroundCoverBtn.alpha = 0
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            // Animate all buttons on side menu bar
            self.profileBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.mapBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.searchBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = CGAffineTransform(translationX: -self.menuCurveImageView.frame.width, y: 0)
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
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        cardH.shouldPresent(cardContent, from: self, fullscreen: true)
        // cell.configurePhotoCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
