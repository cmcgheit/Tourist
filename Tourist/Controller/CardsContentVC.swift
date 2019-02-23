//CardsContentVC.swift, created with love by C McGhee

import UIKit
import Cards

class CardsContentVC: UIViewController {
    
    @IBOutlet weak var placesPhotoView: UITableView!
    @IBOutlet weak var placsTextView: UITextView!
    
    let colors = [
        
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green,
        UIColor.brown,
        UIColor.purple,
        UIColor.orange
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button to open Photo Content
    @IBAction func doMagic(_ sender: Any) {
        
        view.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
}


