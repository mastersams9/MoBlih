//
//  FollowingListTableViewCell.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 03/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

class FollowingListTableViewCell: UITableViewCell {

    @IBOutlet weak var AvatarImageView: UIImageView!
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var CompanyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
