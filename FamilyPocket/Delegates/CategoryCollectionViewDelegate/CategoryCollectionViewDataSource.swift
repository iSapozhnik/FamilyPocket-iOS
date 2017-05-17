//
//  CategoryCollectionViewDataSource.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class CategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var collectionView: UICollectionView!
    let cellIdentidier: String!
    var items: [Category] = [] {
        didSet {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            collectionView.reloadData()
        }
    }
    
    init(withCellIdentifier cellId: String, items: [Any]?, collectionView: UICollectionView) {
        cellIdentidier = cellId
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentidier, for: indexPath)
        
        if let cell = c as? CategoryCollectionViewCell {

            if indexPath.row == items.count {
                cell.bind(categoryName: NSLocalizedString("Add new", comment:""), color: .mainGreenColor(), icon: UIImage(named: "Plus-80.png"))
                
            } else {
                let category = items[indexPath.row]
                let color: UIColor
                if let colorString = category.color {
                    color = colorString.hexColor
                } else {
                    color = .gray
                }
                cell.bind(categoryName: category.name, color: color, icon: UIImage(named: category.iconName ?? ""))
                cell.animate()
            }
        }
        
        return c
    }
    
}
