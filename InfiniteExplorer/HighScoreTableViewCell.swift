//
//  HighScoreTableViewCell.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-20.
//  Author Thomas Irwin
// The Cell Design for the HighScore Table

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    //Holds the Name of the HighScore Players
    @IBOutlet var lblName : UILabel!
    //Holds the Score of the highScore Players
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
