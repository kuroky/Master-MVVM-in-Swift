//
//  LocationTableViewCell.swift
//  Sky
//
//  Created by kuroky on 2019/1/4.
//  Copyright © 2019 Kuroky. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LocationCell"
    @IBOutlet weak var label: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configItem(item: LocationRepresentable) {
        label.text = item.labelText
    }
}
