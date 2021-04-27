//
//  StoreViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var sgtController: UISegmentedControl!
    
//    @IBAction func segmentViewChanged(_ sender: UISegmentedControl) {
//        self.updateView()
//    }
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
        self.setupView()
        // Do any additional setup after loading the view.
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
        print("##########")
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
