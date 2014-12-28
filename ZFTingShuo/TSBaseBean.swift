//
//  TSBaesBean.swift
//  ZFTingShuo
//
//  Created by fminor on 11/23/14.
//
//

import UIKit

class TSBaseBean: NSObject, NSCoding {
    
    var type:String?
    var name:String?
    var id:String?
    
    override init() {
        self.type = ""
        self.name = ""
        self.id = ""
    }
    
    var identity:String? {
        get {
            return type! + name!;
        }
    }
 
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type, forKey:"type")
        aCoder.encodeObject(name, forKey:"name")
        aCoder.encodeObject(id, forKey:"id")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObjectForKey("type") as String?
        self.name = aDecoder.decodeObjectForKey("name") as String?
        self.id = aDecoder.decodeObjectForKey("id") as String?
    }
}
