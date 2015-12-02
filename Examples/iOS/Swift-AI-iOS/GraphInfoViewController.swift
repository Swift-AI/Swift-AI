//
//  GraphInfoViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit

class GraphInfoViewController: UIViewController {
    
    let graphInfoView = GraphInfoView()
    
    override func loadView() {
        self.view = self.graphInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.graphInfoView.dismissButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
    }
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
