//
//  ColorTableViewCell.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorLabel: UILabel!
    
    func bind(colorName: String, color: UIColor) {
        colorLabel.text = colorName
        contentView.backgroundColor = color
    }
    
}
