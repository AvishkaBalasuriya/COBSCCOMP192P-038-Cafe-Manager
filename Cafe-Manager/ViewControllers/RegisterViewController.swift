//
//  RegisterViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func addTapFunctions(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapFunction))
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(tap)
    }
    
    func register(){
        let user = User(emailAddress: txtEmailAddress.text!, mobileNumber: txtMobileNumber.text!, password: txtPassword.text!, type: 1)
        FirebaseService().register(user: user){
            (result:Int?)->Void in
            if(result==201){
                let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarController") as? MainTabBarController
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationItem.leftBarButtonItem=nil
                self.navigationItem.hidesBackButton=true
                self.navigationController?.pushViewController(storeTabBarController!,animated: true)
            }else if(result==409){
                self.showAlert(title: "Oops!", message: "Email is already registered")
            }else if(result==500){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
            }
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(loginViewController!, animated: true)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if(txtEmailAddress.text != "" && txtPassword.text != "" && txtMobileNumber.text != ""){
            if(txtPassword.text!.count>=8){
                if(txtMobileNumber.text!.count==10){
                    register()
                }else{
                    self.showAlert(title: "Oops!", message: "Mobile number needs to be 10 digits")
                }
            }else{
                self.showAlert(title: "Oops!", message: "Password needs to be at least 8 digits")
            }
        }else{
            self.showAlert(title: "Oops!", message: "Please fill all fields")
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
