//
//  TSLoginViewController.swift
//  ZFTingShuo
//
//  Created by fminor on 11/4/14,
//              and to dear 将军.
//

import UIKit

class TSLoginViewController: TSBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var _registerButton: UIButton!
    @IBOutlet weak var _loginbkgImgView: UIImageView!

    @IBOutlet weak var _separator: UIView!
    @IBOutlet weak var _loginContainer: UIView!
    @IBOutlet weak var _userIconImageView: UIImageView!
    @IBOutlet weak var _pwdIconImageView: UIImageView!
    @IBOutlet weak var _userNameTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _userNameTextField.delegate = self
        _passwordTextField.delegate = self
        _loginContainer.layer.borderColor = UIColor(red: (0x97 as CGFloat)/0xFF,
            green:(0x97 as CGFloat)/0xFF, blue: (0x97 as CGFloat)/0xFF, alpha: 1.0).CGColor
        _loginContainer.layer.borderWidth = 0.5
        
        self.initRightManageButton("完成", titleForSelected: nil)
        _rightButton?.addTarget(self, action: "_actionToggleLoginButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let _tapGesture = UITapGestureRecognizer(target: self, action: "_tapMask")
        self.view.addGestureRecognizer(_tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        let _navBkgImage:UIImage? = UIImage(named: "login_nav_bkg")
        self.navigationController?.navigationBar.setBackgroundImage(_navBkgImage!, forBarMetrics: UIBarMetrics.Default)
        
        let _lastLoginUser:TSUser? = TSDataManager.sharedManager().dataForKey(kLastLoginUserIdentity) as TSUser?
        if let _lastUser = _lastLoginUser {
            _userNameTextField.text = _lastUser.name
            _passwordTextField.text = _lastUser.password
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var _💗将军 = _separator.frame;
        _💗将军.size.height = 0.5
        _separator.frame = _💗将军;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    /** text filed delegate */
    
    func textFieldDidBeginEditing(textField: UITextField) {

    }
    
    func textFieldDidEndEditing(textField: UITextField) {

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let _userID = _userNameTextField.text
        let _pwd = _passwordTextField.text
        return true;
    }
    
    /*
        actions
    */
    
    func _tapMask() {
        _userNameTextField.resignFirstResponder()
        _passwordTextField.resignFirstResponder()
    }
    
    func _actionToggleLoginButton() {
        _actionLogin(_userNameTextField.text, password: _passwordTextField.text)
    }
    
    func _actionLoginFail() {
        let _alertView : UIAlertView = UIAlertView(title: nil, message: "登录失败", delegate: nil, cancelButtonTitle: "好的")
        _alertView.show()
    }
 
    func _actionLoginSuccess() {
        let _board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let _alertView : UIAlertView = UIAlertView(title: nil, message: "登录成功", delegate: nil, cancelButtonTitle: "确定")
        _userNameTextField.resignFirstResponder()
        _passwordTextField.resignFirstResponder()
        
        let _user:TSUser = TSUser();
        _user.name = _userNameTextField.text
        _user.password = _passwordTextField.text
        _user.id = _userNameTextField.text
        TSDataManager.sharedManager().setData(_user, forKey: _user.identity!)
        TSDataManager.sharedManager().setData(_user, forKey: kLastLoginUserIdentity)
        
        let _vc:TSTabBarController = _board.instantiateViewControllerWithIdentifier("maintabbar") as TSTabBarController
        self.navigationController?.pushViewController(_vc, animated: true)
    }
    
    func _actionLogin(name: String?, password: String?) {
        var _url_str = "http://42.121.144.167/?type=logon&acc=\(name!)&psw=\(password!)"
        let _url = NSURL(string: _url_str)
        if _url == nil {
            _actionLoginFail()
        }
        let _nsRequest = NSURLRequest(URL: _url!)
        let _request = AFHTTPRequestOperation(request: _nsRequest)
        _request.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject : AnyObject!) -> Void in
            println("登录请求成功！请求链接\(_url!)")
            
            var _dataStr:String? = NSString(data: responseObject as NSData , encoding: NSUTF8StringEncoding)
            if ( _dataStr == "logon failed." ) {
                self._actionLoginFail()
            } else {
                self._actionLoginSuccess()
            }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self._actionLoginFail()
        })
        _request.start()
    }
}
