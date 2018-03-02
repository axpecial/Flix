//
//  MovieCell.swift
//  Flix
//
//  Created by Andy Duong on 2/4/18.
//  Copyright © 2018 Andy Duong. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie? {
        // Property Observers
        // Called just before the value is stored
        willSet( movie ) {}
        // Called just after the value is set
        didSet {
            
            // TODO: Optional or Unwrapped?
            
            titleLabel.text = movie!.title
            overviewLabel.text = movie!.overview
            posterImageView.af_setImage(withURL: movie!.posterURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
