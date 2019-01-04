//
//  SettingTableViewCell.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsTableViewCell"
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
