//
//  StoreViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var sgtController: UISegmentedControl!
    
    lazy var previewViewController:PreviewViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "PreviewViewController") as! PreviewViewController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()
    lazy var categoryViewController:CategoryViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "CategoryViewController") as! CategoryViewController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()
    lazy var menuViewController:MenuViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        self.addViewControllerAsChildViewController(childViewController:viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseService().listenToOrderStatus()
        firestoreDataService().getAllItems(){
            completion in
            
            if completion is [Item]{
                self.setupView()
            }else{
                self.showAlert(title: "Firestore Error", message: "Unable to fetch items")
            }
        }
    }
    
    private func setupView(){
        self.setupSegmentControll()
        self.updateView()
    }
    
    private func updateView(){
        previewViewController.view.isHidden = !(self.sgtController.selectedSegmentIndex==0)
        categoryViewController.view.isHidden = !(self.sgtController.selectedSegmentIndex==1)
        menuViewController.view.isHidden = !(self.sgtController.selectedSegmentIndex==2)
    }
    
    private func setupSegmentControll(){
        self.sgtController.removeAllSegments()
        self.sgtController.insertSegment(withTitle: "Preview", at: 0, animated: false)
        self.sgtController.insertSegment(withTitle: "Category +", at: 1, animated: false)
        self.sgtController.insertSegment(withTitle: "Menu +", at: 2, animated: false)
        self.sgtController.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        self.sgtController.selectedSegmentIndex=0
    }

    @objc func selectionDidChange(sender:UISegmentedControl){
        self.updateView()
    }
    
    func addViewControllerAsChildViewController(childViewController:UIViewController){
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame=view.bounds
        childViewController.view.autoresizingMask=[.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParent: self)
    }
    
    private func removeViewControllerAsChildViewController(childViewController:UIViewController){
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UIViewController{
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
