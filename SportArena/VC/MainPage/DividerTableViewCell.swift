//
//  DividerTableViewCell.swift
//  SportArena
//
//  Created by Alex Kagarov on 4/25/19.
//  Copyright © 2019 Yevgen Blazhko. All rights reserved.
//

import UIKit

class DividerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var divider: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
