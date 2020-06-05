//
//  MLRealmProtocol.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import Realm.Private

public protocol BHRealmProtocol {}
extension BHRealmProtocol {
    /// 插入一条数据
    @discardableResult
    func writeObj()-> Bool {
        if let obj = self as? MLRealmMobject {
            return BHRealmTool<Self>.writeObj(obj: obj)
        }
        return false
    }
    
    /// 插入唯一一条数据
    @discardableResult
    func writeOnlyObj()-> Bool {
        if let obj = self as? MLRealmMobject {
            return BHRealmTool<Self>.writeOnlyObj(obj: obj)
        }
        return false
    }
    
    /// 删除所有数据
    @discardableResult
    static func deleteAllObj()-> Bool {
        return BHRealmTool<Self>.deleteAllObj()
    }
    
    /// 删除一条数据
    func deleteObj()-> Bool {
        if let obj = self as? MLRealmMobject {
            return BHRealmTool<Self>.deleteObj(obj: obj)
        }
        return false
    }
    
    /// 查第一条数据
    static func queryFirstObj()-> Self? {
        return BHRealmTool<Self>.queryFirstObj()
    }
    
    /// 查最后一条数据
    static func queryLastObj()-> Self? {
        return BHRealmTool<Self>.queryLastObj()
    }
    
    /// 取出全部数据
    static func queryAllObj()-> [Self]?{
        return BHRealmTool<Self>.queryAllObj()
    }
    
    /// 主键查询
    /// - Parameter bh_primary_key: 主键
    static func queryObj(withPrimaryKey bh_primary_key: String) -> Self? {
        return BHRealmTool<Self>.queryObj(withPrimaryKey: bh_primary_key)
    }
    
    /// 条件查询
    /// - Parameter filter: 查询语句
    static func queryObjs(filter: String)-> [Self]? {
        return BHRealmTool<Self>.queryObjs(filter: filter)
    }
}

extension Array where Element: BHRealmProtocol {
    /// 插入一组数据
    @discardableResult
    func writeObjs()-> Bool {
        if let objs = self as? [MLRealmMobject] {
            return BHRealmTool<Element>.writeObjs(objs: objs)
        }
        return false
    }
    
    /// 删除一组数据
    @discardableResult
    func deleteObjs()-> Bool {
        if let objs = self as? [MLRealmMobject] {
            return BHRealmTool<Element>.deleteObjs(objs: objs)
        }
        return false
    }
}

class BHRealmTool<T: BHRealmProtocol> {
    
    @discardableResult
    //MARK: - 增
    /// 插入一条数据
    class func writeObj(obj: MLRealmMobject)-> Bool {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return false
        }
        do{
            try realm.write {
                realm.add(obj)
            }
            return true
        }catch{
            mlLog("Realm保存报错")
            return false
        }
    }
    
    @discardableResult
    /// 写入唯一一条数据
    /// - Parameter obj: 数据
    class func writeOnlyObj(obj: MLRealmMobject)-> Bool {
        if BHRealmTool.deleteAllObj() == true {
            return BHRealmTool.writeObj(obj: obj)
        }else{
            return false
        }
    }
    
    /// 插入多条数据
    /// - Parameter objs: 对象
    @discardableResult
    class func writeObjs(objs: [MLRealmMobject])-> Bool {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return false
        }
        do{
            try realm.write {
                realm.add(objs)
            }
            return true
        }catch{
            mlLog("Realm保存报错")
            return false
        }
    }
    
    //MARK: - 删
    /// 删除表中所有数据
    @discardableResult
    class func deleteAllObj()-> Bool {
        guard let objs = BHRealmTool.queryAllObj() as? [MLRealmMobject] else { return false }
        return BHRealmTool.deleteObjs(objs: objs)
    }
    
    /// 删除某条数据
    class func deleteObj(obj: MLRealmMobject)-> Bool {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return false
        }
        do{
            try realm.write {
                realm.delete(obj)
            }
            return true
        }catch{
            mlLog("Realm删除全部失败")
            return false
        }
    }
    
    /// 删除一组数据
    /// - Parameter objs: 数据组
    class func deleteObjs(objs: [MLRealmMobject])-> Bool {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return false
        }
        do{
            try realm.write {
                realm.delete(objs)
            }
            return true
        }catch{
            mlLog("Realm删除全部失败")
            return false
        }
    }
    
    //MARK: - 查
    /// 查第一条数据
    class func queryFirstObj()-> T? {
        return BHRealmTool.queryAllObj()?.first
    }
    
    /// 查最后一条数据
    class func queryLastObj()-> T? {
        return BHRealmTool.queryAllObj()?.last
    }
    
    /// 查所有数据
    class func queryAllObj()-> [T]? {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return nil
        }
        if let type = T.self as? MLRealmMobject.Type {
            let objects = realm.objects(type.self)
            var modes: [T] = [T]()
            for obj in objects {
                if let model = obj as? T {
                    modes.append(model)
                }
            }
            return modes
        }else{
            mlLog("转换错误")
            return nil
        }
    }
    
    /// 通过主键查询
    /// - Parameter bh_primary_key: 主键
    class func queryObj(withPrimaryKey bh_primary_key: String) -> T? {
        return BHRealmTool.queryObjs(filter: String(format: "bh_primary_key = %@", bh_primary_key))?.first
    }
    
    /// 条件查询
    /// - Parameter filter: 查询语句
    class func queryObjs(filter: String)-> [T]? {
        guard let realm: Realm = MLRealm.instance.realm() else {
            mlLog("realm为空")
            return nil
        }
        if let type = T.self as? MLRealmMobject.Type {
            let objects = realm.objects(type.self).filter(NSPredicate(format: filter))
            var modes: [T] = [T]()
            for obj in objects {
                if let model = obj as? T {
                    modes.append(model)
                }
            }
            return modes
        }
        return nil
    }
    
}

