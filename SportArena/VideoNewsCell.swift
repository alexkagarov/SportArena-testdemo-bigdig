//
//  VideoNewsCell.swift
//  SportArena
//
//  Created by Yevgen Blazhko on 8/30/18.
//  Copyright © 2018 Yevgen Blazhko. All rights reserved.
//

import UIKit

class VideoNewsCell: UITableViewCell {
    
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var titleVideo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
