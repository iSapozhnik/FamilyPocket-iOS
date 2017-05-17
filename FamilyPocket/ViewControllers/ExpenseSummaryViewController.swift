//
//  ExpenseSummaryViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenseSummaryViewController: UIViewController {
    
    lazy var expenseManager = ExpenseManager()
    let cellIdentifier = "cellIdentifier"
    
    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Expense]! = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    init() {
        super.init(nibName: ExpenseSummaryViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ExpenseSummaryViewController viewDidLoad")
        tableView.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenseManager = ExpenseManager()
        expenseManager.allObjects { [weak self] (expenses) in
            if let expenses = expenses {
                print("Expenses: \(expenses)")
                self?.items = expenses
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
