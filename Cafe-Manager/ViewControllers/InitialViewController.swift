//
//  SplashViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let isLogged=UserDefaults.standard.bool(forKey: "isLogged")
        if isLogged{
            let user = User()
            user.emailAddress=UserDefaults.standard.string(forKey: "emailAddress")!
            user.mobileNumber=UserDefaults.standard.string(forKey: "mobileNumber")!
            user.uuid=UserDefaults.standard.string(forKey: "uuid")!
            setUserData(user: user)
            
            let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarController") as? MainTabBarController
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationItem.leftBarButtonItem=nil
            self.navigationItem.hidesBackButton=true
            self.navigationController?.pushViewController(storeTabBarController!,animated: true)
        }else{
            let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationItem.leftBarButtonItem=nil
            self.navigationItem.hidesBackButton=true
            self.navigationController?.pushViewController(storeTabBarController!,animated: true)
        }
    }

}
