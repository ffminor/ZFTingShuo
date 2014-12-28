//
//  TSUser.swift
//  ZFTingShuo
//
//  Created by fminor on 11/23/14.
//
//

import UIKit

let kLastLoginUserIdentity                  = "kLastLoginUserIdentity"

class TSUser: TSBaseBean {
   
    var password:NSString?
    
    override init() {
        super.init()
        self.type = "TSUser";
        self.password = "";
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.password, forKey: "password")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.password = aDecoder.decodeObjectForKey("password") as NSString?
    }
}
