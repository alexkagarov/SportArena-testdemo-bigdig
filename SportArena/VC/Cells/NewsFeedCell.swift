//
//  NewsFeedCell.swift
//  SportArena
//
//

import UIKit

class NewsFeedCell: UITableViewCell {

    @IBOutlet weak var newsFeedTitle: UILabel!
    @IBOutlet weak var newsFeedTopic: UILabel!
    @IBOutlet weak var newsFeedTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
