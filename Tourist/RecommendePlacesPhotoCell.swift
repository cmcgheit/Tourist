// RecommendedPlacesPhotoCell, created with love by C McGhee

import UIKit
import Cards

class RecommendedPlacesPhotoCell: UITableViewCell {
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    // Setup Photo Cell
    func configureRecCell() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup Photo Card prog
        let photoCard = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
        
        photoCard.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) // white
        photoCard.backgroundImage = photosImageView.image // set background image
        photoCard.title = "Recommended Place"
        photoCard.itemTitle = "City Name"
        photoCard.itemSubtitle = "City State"
        photoCard.textColor = UIColor(red: 137/255, green: 194/255, blue: 201/255, alpha: 1) // teal green
        
        photoCard.hasParallax = true
    }
}
