//
//  ExpenseSummaryViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ExpenseSummaryViewController: UIViewController {

    @IBOutlet weak var titleLabel: ALabel!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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