//
//  ViewController.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view  = YYDrawView(frame: CGRectMake(0, 20, 300, 400), lineColor: "#FF000000")
        view.drawLineCompletion = {model in
            print(model)
        
        }
        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

