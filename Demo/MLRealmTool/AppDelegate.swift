//
//  AppDelegate.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化
        MLRealm.setupConfigInfo(dbVer: MLRealmConfig.dbVer, encryptKey: MLRealmConfig.encryptKey)
        return true
    }
}

