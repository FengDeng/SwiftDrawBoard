//
//  YYDrawModel.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import UIKit

public class YYDrawLineModel: NSObject {
    
    public var pointList = [YYDrawPointModel]()
    public var paintColor = "d1d1d1"
    public var paintSize : NSNumber = 1
    public var isEraser : NSNumber = 0

}
