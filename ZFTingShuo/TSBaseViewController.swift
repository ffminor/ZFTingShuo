//
//  TSBaseViewController.swift
//  TingShuo
//
//  Created by fminor on 10/7/14.
//                      To dear 将军.
//

import UIKit

let _indicator_width:CGFloat = 200.0
let _indicator_height:CGFloat = 100.0

class TSBaseViewController: UIViewController {
    
    var _indicatorView:UIView = UIView()
    var _rightButton:UIButton?
    var _rightManageButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back indicator
        let _backIndicator = UIButton(frame: CGRectMake(0, 0, 12, 20.5))     // (image: UIImage(named: "nav_back"))
        _backIndicator.setImage(UIImage(named: "nav_back"), forState: UIControlState.Normal)
        _backIndicator.addTarget(self, action: "_backButtonTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        let _leftBarButton = UIBarButtonItem(customView: _backIndicator)
        self.navigationItem.leftBarButtonItem = _leftBarButton
        
        // _indicator view
        _indicatorView.frame = CGRectMake(
            0.5 * (self.view.bounds.size.width - _indicator_width),
            0.5 * (self.view.bounds.size.height - _indicator_height),
            _indicator_width,
            _indicator_height
        );
        _indicatorView.alpha = 0;
        self.view.addSubview(_indicatorView);

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // right manager button
    
    func initRightManageButton(titleForNormal: String, titleForSelected: String?) {
        _rightButton = UIButton(frame: CGRectMake(0, 0, 60, 30))
        _rightButton?.setTitle(titleForNormal, forState: UIControlState.Normal)
        if let _selectedTitle = titleForSelected {
            _rightButton?.setTitle(_selectedTitle, forState: UIControlState.Selected)
        }
        _rightButton?.titleLabel?.font = _rightButton?.titleLabel?.font.fontWithSize(15.0)
        _rightManageButton = UIBarButtonItem(customView: _rightButton!)
        self.navigationItem.rightBarButtonItem = _rightManageButton
    }
    
    // internal
    
    func _backButtonTouchUpInside(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
