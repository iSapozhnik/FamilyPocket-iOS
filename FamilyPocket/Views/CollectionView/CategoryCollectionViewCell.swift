//
//  CategoryCollectionViewCell.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(categoryName: String) {
        titleLabel.text = categoryName
    }

}
