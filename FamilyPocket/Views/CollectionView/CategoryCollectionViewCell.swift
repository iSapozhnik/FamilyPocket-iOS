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
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(categoryName: String, color: UIColor, icon: UIImage?) {
        titleLabel.text = categoryName
        contentView.backgroundColor = color
        iconView.image = icon
    }
    
    func animate() {
        
        self.iconLeftConstraint.constant = -30.0
        self.contentView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.iconLeftConstraint.constant = 20.0
            self.contentView.layoutIfNeeded()
        }, completion: nil)
    }
}
