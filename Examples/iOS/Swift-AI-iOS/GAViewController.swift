//
//  GAViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/25/15.
//

import UIKit

class GAViewController: UIViewController {
    
    let gaView = GAView()
    
    override func loadView() {
        self.view = self.gaView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
