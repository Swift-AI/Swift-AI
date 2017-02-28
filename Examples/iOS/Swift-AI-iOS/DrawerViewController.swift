//
//  DrawerViewController.swift
//
//  Created by Collin Hundley on 9/1/15.
//

import UIKit

class DrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    let drawerView = DrawerView()
    var viewControllers = [UIViewController]()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func loadView() {
        self.view = self.drawerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawerView.tableView.dataSource = self
        self.drawerView.tableView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedFeedback))
        self.drawerView.footerView.addGestureRecognizer(tapRecognizer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DrawerCell()
        cell.titleLabel.text = self.viewControllers[indexPath.row].title!
        switch indexPath.row {
        case 0:
            cell.descriptionLabel.text = "Artificial Neural Network"
        case 1:
            cell.descriptionLabel.text = "Artificial Neural Network"
        case 2:
            cell.descriptionLabel.text = "Artificial Neural Network"
        default:
            cell.descriptionLabel.text = "Genetic Algorithm"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DrawerNavigationController.globalDrawerController().switchToViewAtIndex(indexPath.row, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tappedFeedback() {
        let url = URL(string: "https://github.com/collinhundley/Swift-AI/issues/new")!
        UIApplication.shared.openURL(url)
    }

}
