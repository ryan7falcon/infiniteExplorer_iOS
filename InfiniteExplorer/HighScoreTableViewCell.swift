//
//  HighScoreTableViewCell.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-20.
//  Copyright © 2017 Ryan Falcon. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblScore : UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
