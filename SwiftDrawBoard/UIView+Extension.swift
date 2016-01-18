//
//  UIView+Extension.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    public func yy_scrollView()->UIScrollView? {
        
        var scrollView = self.superview
        
        while let view = scrollView?.superview {
            scrollView = view
            if scrollView!.isKindOfClass(UIScrollView.self){
                return scrollView as? UIScrollView
            }
        }
        
        return nil
    }
    public func yy_tableView()->UITableView? {
        
        var tableView = self.superview
        
        while let view = tableView?.superview {
            tableView = view
            if tableView!.isKindOfClass(UITableView.self){
                return tableView as? UITableView
            }
        }
        
        return nil
    }

}
