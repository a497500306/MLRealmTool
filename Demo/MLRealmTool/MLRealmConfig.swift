//
//  MLRealmConfig.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit

class MLRealmConfig {
    
    /// 数据库加密KEY
    static let encryptKey : Data = "A1234567890987654321qwertyuioplkjhgfdsazxcvbnm8gruodchgwpjsziub8".data(using: String.Encoding.utf8, allowLossyConversion: true) ?? Data()
    
    /// 数据库版本号
    static let dbVer : __uint64_t = 1
    
}
