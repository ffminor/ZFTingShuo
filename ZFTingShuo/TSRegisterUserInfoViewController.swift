//
//  TSRegisterUserInfoViewController.swift
//  TingShuo
//
//  Created by fminor on 9/27/14.
//              To dear 将军.
//

import UIKit

// http://42.121.144.167/?type=modify&acc=12345&psw=45634&item=nk&value=test1

class TSRegisterUserInfoViewController:
    TSBaseViewController,
    UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var _nickNameTextField: UITextField!
    @IBOutlet weak var _uploadButton: UIButton!
    
    var account:String = "";
    var password:String = "";
    var imageData:NSData?;
    var profileImage:UIImage?;
    
    var _imagePickerController:UIImagePickerController = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _uploadButton.layer.cornerRadius = 0.5 * _uploadButton.bounds.size.width;
        _uploadButton.clipsToBounds = true;
        
        self.initRightManageButton("完成", titleForSelected: nil)
        _rightButton?.addTarget(self, action: "_actionFinishRegsiter",
                                forControlEvents: UIControlEvents.TouchUpInside);

        _nickNameTextField.delegate = self;
        _imagePickerController.delegate = self;
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // button actions
    //

    @IBAction func _actionUploadBtn(sender: AnyObject) {
//        var _sheet:UIActionSheet = UIActionSheet(title: "上传图片", delegate: self, cancelButtonTitle: "取消", : "从手机相册上传")
        var _sheet = UIActionSheet(title: "上传图片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","从手机相册上传")
        _sheet.showInView(self.view)
    }
    
    func _actionFinishRegsiter() {
        
        println("准备上传注册信息...");
        let _nkName = _nickNameTextField.text;
        let _imagePath = "";
        
        println("上传头像")
        let _uploaderMGR:UploadTokenManager = UploadTokenManager()
        _uploaderMGR.uploadImage(self.profileImage, key: _nkName! + ".png")
        
        var _urlStr = "http://42.121.144.167/?type=modify&acc=" + self.account + "&psw=" + self.password + "&item=nk&value=" + _nkName!
        println("url:\(_urlStr)");
        
        var _url = NSURL(string: _urlStr)
//        var _url = NSURL(string: _urlStr);
//        if _url == nil {
//            return;
//        }
        let _urlReq = NSURLRequest(URL: _url!);
        
        var _request:AFHTTPRequestOperation = AFHTTPRequestOperation(request: _urlReq)
        _request.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, AnyObject) -> Void in
            var _dataStr:String? = NSString(data:AnyObject as NSData , encoding: NSUTF8StringEncoding)
            if ( _dataStr == "modify ok." ) {
                
                println("register ok!");
                self.navigationController?.setNavigationBarHidden(true, animated: false);
                
                var _storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var _tabBarController:TSTabBarController = _storyBoard.instantiateViewControllerWithIdentifier("maintabbar") as TSTabBarController;
                self.navigationController?.pushViewController(_tabBarController, animated: true);
                
            } else {
                
            }
            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                println(NSError);
        })
        _request.start()
}
    
    //
    // action sheet delegate
    //
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        let _logStr:String = "press button:\(buttonIndex)";
        println(_logStr);
        
        if buttonIndex == 1 {
            _imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            _imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(_imagePickerController, animated: true, completion:nil)
    }
    
    //
    // image picker delegate
    //

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("image picker delegate!")
        picker.popViewControllerAnimated(true)
        _uploadButton.setImage(image, forState: UIControlState.Normal)
        self.profileImage = image;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("image picker did take photo!")
        picker.dismissViewControllerAnimated(true, completion: nil)
        let _dict:Dictionary = info
        let _originImg =  _dict[UIImagePickerControllerOriginalImage] as UIImage
        _uploadButton.setImage(_originImg, forState: UIControlState.Normal)
        self.profileImage = _originImg
    }
}
