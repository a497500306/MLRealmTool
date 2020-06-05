//
//  MLRealm.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import Realm.Private

public func mlLog(_ items: Any){
    #if DEBUG
    print(items)
    #endif
}

class MLRealm {
    
    static let instance : MLRealm = MLRealm()
    
    var realmConfig : Realm.Configuration?
    
    /// 初始化
    class func setupConfigInfo(dbVer: UInt64, encryptKey: Data) {
        if MLRealm.instance.realmConfig == nil {
            var config = Realm.Configuration()
            config.schemaVersion = dbVer
            config.encryptionKey = encryptKey
            if let encryptionKey = config.encryptionKey, let str = String(data: encryptionKey, encoding: String.Encoding.utf8) {
                mlLog("数据库秘钥:" + str)
            }else {
                mlLog("数据库秘钥:未找到,可能有问题")
            }
            if let fileURL = config.fileURL?.absoluteString {
                mlLog("数据库地址:" + fileURL)
            }else{
                mlLog("数据库地址:未找到,可能有问题")
            }
            MLRealm.instance.realmConfig = config
        }
    }

    /// 跨线程读写数据会出问题，必须每次都实例化一个最新的
    func realm()->Realm? {
        if self.realmConfig != nil {
            if let realmConfig = MLRealm.instance.realmConfig {
                do{
                    return try Realm(configuration: realmConfig)
//                }catch let error as NSError {
                }catch{
                    mlLog("主线程中Realm报错")
                    return nil
                }
            }else{
                mlLog("主线程中Realm创建失败")
                return nil
            }
        }else{
            do{
                return try Realm()
            }catch{
                mlLog("多线程中Realm报错")
                return nil
            }
        }
    }
}
