//
//  MLRealmMobject.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import Realm.Private

class MLRealmMobject: Object, BHRealmProtocol {
    
    /// 必须设置一个主键
    @objc dynamic var ml_primary_key : String = UUID().uuidString
    
    /// 记录创建时间
    @objc dynamic var ml_created_time = Date()
    
    public required init() {
        super.init()
    }
    
    /// 设置主键
    override static func primaryKey() -> String? {
        return "ml_primary_key"
    }
    
}
