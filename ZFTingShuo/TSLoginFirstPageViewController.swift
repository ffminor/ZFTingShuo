//
//  TSLoginFirstPageViewController.swift
//  ZFTingShuo
//
//  Created by fminor on 12/7/14.
//              To dear 将军.
//

import UIKit

class TSLoginFirstPageViewController: UIViewController {

    @IBOutlet weak var _registerButton: UIButton!
    @IBOutlet weak var _loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _loginButton.layer.cornerRadius = 3
        _loginButton.clipsToBounds = true
        
        _registerButton.layer.cornerRadius = 3
        _registerButton.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func _actionToggleRegisterButton(sender: AnyObject) {
    }
    
    @IBAction func _actionToggleLoginButton(sender: AnyObject) {
    }

}
