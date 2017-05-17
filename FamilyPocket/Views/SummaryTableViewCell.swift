//
//  SummaryCategoryTableViewCell.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(withValue value: String, dateString: String, categoryImage: UIImage?, categoryColor: UIColor, categoryName: String) {
        
        contentView.backgroundColor = categoryColor
        iconView.image = categoryImage
        valueLabel.text = value
        dateLabel.text = dateString
        categoryNameLabel.text = categoryName
    }
    
}
