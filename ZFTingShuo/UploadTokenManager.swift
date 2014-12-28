//
//  UploadTokenManager.swift
//  TingShuo
//
//  Created by fminor on 10/15/14.
//
//

import UIKit

class UploadPolicy: NSObject {
    
    var scope:String = ""
    var deadline:Int = 0
    var secretKey = "Z0eIShWiBILCc-MdZCpEDx3q7AedF2Im7ASZ1Y2N"
    
    var jsonString:String {
        get {
            var _result = "{";
            _result += "\"scope\":\"" + self.scope + "\"";
            _result += ",";
            _result += "\"deadline\":" + self.deadline.description;
            _result += ",";
            _result += "\"returnBody\":\"{\\\"name\\\":$(fname),\\\"size\\\":$(fsize),\\\"w\\\":$(imageInfo.width),\\\"h\\\":$(imageInfo.height),\\\"hash\\\":$(etag)}\"}";
            return _result;
        }
    }
    
    func sha1(key: NSString) -> String {
        var _result = ""
        return _result
    }
}

class UploadTokenManager: NSObject {
    
    var uploadPolicy: UploadPolicy = UploadPolicy()
    
    var message: NSString? = ""
    var encodeSign: NSString? = ""
    var secretKey = "Z0eIShWiBILCc-MdZCpEDx3q7AedF2Im7ASZ1Y2N"
    var accessKey: String = "r0EnHnGsEb9vyVDggmjgfNtdcQBtwfMbl1buC1R2"
    
    var scopeKey: String? {
        set {
            self.uploadPolicy.scope = "tingshuo-ios-test:" + newValue!
        }
        
        get {
            return self.scopeKey
        }
    }
    
    var uploadToken: NSString {
        get {
            var _token:NSString = "\(self.accessKey):\(self.encodeSign!):\(self.message!)"
            return _token
        }
    }
    
    func base64(message:String) -> String? {
        var _data:NSData? = message.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        return _data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    }
    
    func uploadImage(image:UIImage?, key:NSString) {
        
        self.scopeKey = key
        
        let _date = NSDate(timeIntervalSinceNow: 3600 * 24 * 365 * 5 )
        self.uploadPolicy.deadline = (Int)(_date.timeIntervalSince1970)
        
        let _jsonStr = self.uploadPolicy.jsonString
        let _base64 = self.base64(_jsonStr)
        
        self.message = _base64
        let _encode: NSData = TSKeySignature.hmacSha1(self.uploadPolicy.secretKey, text: self.message!)
        self.encodeSign = _encode.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        println("Token: \(self.uploadToken)")
        
        let _uploader:QiniuSimpleUploader = QiniuSimpleUploader(token: self.uploadToken)
        let _imageData = UIImagePNGRepresentation(image)
        _uploader .uploadFileData(_imageData, key: key, extra: nil)
    }
}
