//
//  YYDrawModel.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import UIKit
import MJExtension

public class YYDrawModel: NSObject {
    public var lines = [YYDrawLineModel]()
    public var width : NSNumber = 0
    public var height : NSNumber = 300
    public var backImangeURL = ""
    
    override public static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["lines":YYDrawLineModel.self]
    }
    
}
