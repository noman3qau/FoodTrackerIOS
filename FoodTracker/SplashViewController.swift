//
//  SpalshController.swift
//  FoodTracker
//
//  Created by Noman on 4/11/18.
//  Copyright © 2018 EvampSaanga. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
     var splashTimer: Timer! //Timer object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        splashTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeaction), userInfo: nil, repeats: true)

        
    }
    
    
    //Timer action
    @objc func timeaction(){
        
        //code for move next VC
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(loginViewController, animated: true)

        splashTimer.invalidate()//after that timer invalid
        
    }
    
    
    
}

