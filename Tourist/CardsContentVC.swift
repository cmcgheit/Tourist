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
    
    @IBAction func doMagic(_ sender: Any) {
        
        view.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
    }
}

// MARK: - Photos Table View Functions
extension CardsContentVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesPhotoCell", for: indexPath)
        let cardH = cell.viewWithTag(2) as! CardHighlight
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        cardH.shouldPresent(cardContent, from: self, fullscreen: true)
        return cell
    }
}
