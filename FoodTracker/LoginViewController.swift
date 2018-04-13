//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Noman on 4/11/18.
//  Copyright © 2018 EvampSaanga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var registerLabel: UILabel!

    //MARK: Actions
    @IBAction func loginButton(_ sender: Any) {
        if !(emailInputField.text?.isEmpty)! && !(passwordInputField.text?.isEmpty)! {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MealTableViewController") as? MealTableViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            showErrorAlert();
        }
    }
    
    @objc func goToRegisterPage(){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    func showErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Please enter Email and Password.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.goToRegisterPage))
        registerLabel.isUserInteractionEnabled=true
        registerLabel.addGestureRecognizer(tap)
        
    }
    
    
    
}
