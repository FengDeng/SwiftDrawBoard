//
//  YYDrawPointModel.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import UIKit

public class YYDrawPointModel: NSObject {
    
    public var x : NSNumber = 0
    public var y : NSNumber = 0
    
    convenience init(point:CGPoint){
        self.init()
        self.x = NSNumber(float: Float(point.x))
        self.y = NSNumber(float: Float(point.y))
    }

}
