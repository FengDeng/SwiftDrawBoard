//
//  UIColor+Extension.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    /**
     *  因为其他平台的透明度都在最后面，#AARRGGBB->#RRGGBBAA
     */
    class func yy_hexString(hex:String)->UIColor{
        if (hex as NSString).length != 9{
            return UIColor(rgba: "#000000")
        }
        let str1 = (hex as NSString).substringWithRange(NSMakeRange(0, 1))
        let str2 = (hex as NSString).substringWithRange(NSMakeRange(1, 2))
        let str3 = (hex as NSString).substringWithRange(NSMakeRange(3, 6))
        return UIColor(rgba: str1 + str3 + str2)
    }
}
