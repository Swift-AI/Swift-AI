//
//  DrawerViewController.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit
import APKit

class DrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    let drawerView = DrawerView()
    var viewControllers = [UIViewController]()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    
    override func loadView() {
        self.view = self.drawerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawerView.tableView.dataSource = self
        self.drawerView.tableView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedFeedback")
        self.drawerView.footerView.addGestureRecognizer(tapRecognizer)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = DrawerCell()
        cell.titleLabel.text = self.viewControllers[indexPath.row].title!
        switch indexPath.row {
        case 0:
            cell.descriptionLabel.text = "Artificial Neural Network"
        case 1:
            cell.descriptionLabel.text = "Artificial Neural Network"
        default:
            cell.descriptionLabel.text = "Genetic Algorithm"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DrawerNavigationController.globalDrawerController().switchToViewAtIndex(indexPath.row, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tappedFeedback() {
        let url = NSURL(string: "https://github.com/collinhundley/Swift-AI/issues/new")!
        UIApplication.sharedApplication().openURL(url)
    }

}
