//
//  TSDataManager.swift
//  ZFTingShuo
//
//  Created by fminor on 11/23/14.
//
//

import UIKit

let _dataCacheName = "TSDataCache"

var _gDataManager:TSDataManager?;

class TSDataManager: NSObject {
    
    var _dataCache:PYGlobalDataCache
    
    override init() {
        PYGlobalDataCache.initializeSqliteForMultipleThread()
        _dataCache = PYGlobalDataCache.gdcWithIdentify(_dataCacheName)
    }
    
    func setData(data:NSCoding, forKey:String) {
        let _data = NSKeyedArchiver.archivedDataWithRootObject(data)
        _dataCache.setObject(_data, forKey: forKey)
    }
    
    func dataForKey(key:String) -> AnyObject? {
        var _object:NSData? = _dataCache.objectForKey(key) as NSData?
        if let _hasObject = _object {
            return NSKeyedUnarchiver.unarchiveObjectWithData(_hasObject)
        } else {
            return nil
        }
    }
    
    class func sharedManager() -> TSDataManager {
        if _gDataManager == nil {
            _gDataManager = TSDataManager()
        }
        return _gDataManager!
    }
}
