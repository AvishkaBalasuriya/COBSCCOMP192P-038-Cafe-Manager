//
//  LoginViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var lblForgetPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    @IBAction func loginUser(_ sender: Any) {
        let user = User(emailAddress: txtEmailAddress.text!, password: txtPassword.text!)
        FirebaseService().login(user: user) {
            result in
            if result == 200{
                firestoreDataService().fetchUser(user: user){
                    completion in
                    print(completion)
                    if completion is User{
                        let user = completion as! User
                        if user.type==1{
                            FirebaseService().listenToOrderStatus()
                            let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarController") as? MainTabBarController
                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                            self.navigationItem.leftBarButtonItem=nil
                            self.navigationItem.hidesBackButton=true
                            self.navigationController?.pushViewController(storeTabBarController!,animated: true)
                        }else{
                            self.showAlert(title: "Oops!", message: "You are unauthorized")
                        }
                    }else{
                        self.showAlert(title: "Firestore Error", message: "Unable to fetch user data")
                    }
                }
            }else if(result==400){
                self.showAlert(title: "Oops!", message: "Email address and password is required")
            }else if(result==401){
                self.showAlert(title: "Oops!", message: "Username or password is incorrect")
            }else if(result==500){
                self.showAlert(title: "Oops!", message: "An error occures while logging")
            }
        }
    }
    
    func addTapFunctions(){
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.registerTapFunction))
        lblRegister.isUserInteractionEnabled = true
        lblRegister.addGestureRecognizer(registerTap)
        
        let forgetPasswordTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.forgetPasswordTapFunction))
        lblForgetPassword.isUserInteractionEnabled = true
        lblForgetPassword.addGestureRecognizer(forgetPasswordTap)
    }
    
    @objc func registerTapFunction(sender:UITapGestureRecognizer) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier:"RegisterViewController") as? RegisterViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(registerViewController!, animated: true)
    }
    
    @objc func forgetPasswordTapFunction(sender:UITapGestureRecognizer) {
        let forgetPasswordViewController = storyboard?.instantiateViewController(withIdentifier:"ForgetPasswordViewController") as? ForgetPasswordViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(forgetPasswordViewController!, animated: true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
