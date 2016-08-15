//
//  TrackCell.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/1/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import AlamofireImage
import SWTableViewCell

class TrackCell: SWTableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var artistslbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(track: Track){
        if let title = track.title{
            titlelbl.text = title
        }
        
        if let artists = track.artistsToDisplay{
            artistslbl.text = artists
        }
        
    }
    
    func configureCellWithURLString(URLString: String, placeholderImage: UIImage) {
        
        let size = CGSizeMake(113, 113)
        
        albumImage.af_setImageWithURL(
            NSURL(string: URLString)!,
            placeholderImage: UIImage(named: "placeholder"),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 0.0),
            imageTransition: .CrossDissolve(0.2)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImage.af_cancelImageRequest()
        albumImage.layer.removeAllAnimations()
        albumImage.image = nil
    }
    


}
