//
//  LoginVC.swift
//  BitPoloniex
//
//  Created by Saleh on 1/26/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit

class LoginVC: UITableViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    @IBAction func login(_ sender: Any) {
        if let user : User = AppUserDefaults.getUser() {
            if self.usernameText.text?.lowercased() == user.email, self.passwordText.text == user.password {
                
                let homeVc : HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                
                let nav : UINavigationController = UINavigationController(rootViewController: homeVc)
                
                self.present(nav, animated: true, completion: nil)
                
            } else {
                let avc : UIAlertController = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
                avc.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                    
                }))
                self.present(avc, animated: true, completion: nil)
            }
            
        } else {
            
            // I know strings should be in a Strings file for localization but this is for deme purposes.
            
            let avc : UIAlertController = UIAlertController(title: "Not Registered", message: "You need to register first", preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
            }))
            self.present(avc, animated: true, completion: nil)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        
    }
    
}
