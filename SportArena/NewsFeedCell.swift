//
//  NewsFeedCell.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/9/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit

class NewsFeedCell: UITableViewCell {

    @IBOutlet weak var newsfeed_title: UILabel!
    @IBOutlet weak var newsfeed_topic: UILabel!
    @IBOutlet weak var newsfeed_time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
