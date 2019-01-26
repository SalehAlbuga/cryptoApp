//
//  RegisterationVC.swift
//  BitPoloniex
//
//  Created by Saleh on 1/26/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit

class RegisterationVC: UITableViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    
    @IBAction func register(_ sender: Any) {
        guard let name : String = nameText.text, let email : String = emailText.text?.lowercased(), let pass : String = password.text else {
            let avc : UIAlertController = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
            }))
            self.present(avc, animated: true, completion: nil)
            return
        }
        
        var user : User = User()
        
        user.fullName = name
        user.email = email
        user.password = pass
        
        AppUserDefaults.set(user: user)
        
        let homeVc : HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
        let nav : UINavigationController = UINavigationController(rootViewController: homeVc)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
