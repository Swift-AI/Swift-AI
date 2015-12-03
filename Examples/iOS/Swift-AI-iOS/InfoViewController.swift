//
//  InfoViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 11/30/15.
//

import UIKit

class InfoViewController: UIViewController {
    
    let infoView = InfoView()
    
    override func loadView() {
        self.view = self.infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoView.dismissButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
    }
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
