//
//  YYDrawView.swift
//  SwiftDrawBoardDemo
//
//  Created by 邓锋 on 16/1/18.
//  Copyright © 2016年 fengdeng. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

extension String{
}

extension NSNumber{
    func CGFloatValue()->CGFloat{
        return CGFloat(self.floatValue)
    }
}

class YYLinePath : UIBezierPath{
    convenience init(startPoint:CGPoint,lineWith:CGFloat){
        self.init()
        self.lineWidth = lineWith
        self.lineCapStyle = .Round
        self.lineJoinStyle = .Round
        self.moveToPoint(CGPoint(x: startPoint.x, y: startPoint.y))
    }
}

class YYSettingView : UIView{
    var penOrEraseBtn : UIButton!
    var undoBtn : UIButton!
    var redoBtn : UIButton!
    var addHeightBtn : UIButton!
    var clearBtn : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.penOrEraseBtn = UIButton(frame: CGRectMake(0,0,80,30))
        self.penOrEraseBtn.setTitle("当前画笔", forState: .Normal)
        
        self.undoBtn = UIButton(frame: CGRectMake(80,0,40,30))
        self.undoBtn.setTitle("后退", forState: .Normal)
        
        self.redoBtn = UIButton(frame: CGRectMake(120,0,40,30))
        self.redoBtn.setTitle("前进", forState: .Normal)
        
        self.addHeightBtn = UIButton(frame: CGRectMake(160,0,40,30))
        self.addHeightBtn.setTitle("添纸", forState: .Normal)
        
        self.clearBtn = UIButton(frame: CGRectMake(200,0,40,30))
        self.clearBtn.setTitle("清屏", forState: .Normal)
        
        
        self.addSubview(self.penOrEraseBtn)
        self.addSubview(undoBtn)
        self.addSubview(redoBtn)
        self.addSubview(clearBtn)
        self.addSubview(addHeightBtn)
        
        self.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class YYDrawView: UIView {
    
    var path = YYLinePath() //当前线的路径
    var caLayer = CAShapeLayer() //当前的shapeLayer
    var lines = [CAShapeLayer]() //所有的线条layer
    var deleteLines = [CAShapeLayer]() //被删除线条layer
    public var lineColor = ""{ //当前线的颜色
        didSet{
            self.clipsToBounds = true
        }
    }
    var lineWidth : CGFloat = 1 //当前线的宽度
    public var lineType  = 0 //当前线的类型，0是铅笔，1是橡皮
    public var drawLineCompletion : ((YYDrawModel)->Void)?//绘制一条线完毕后的回调
    public var addHeightCompletion : ((YYDrawModel)->Void)?//绘制一条线完毕后的回调
    public var changeLineType : (Bool ->Void)? //线的属性回调，yes是线，no是橡皮
    
    public var drawModels = [YYDrawModel](){//当前所有待绘图的模型，不可改变
        didSet{
            self.clear()
            for model in self.drawModels{
                self.yy_DrawModel(model,addLines:false)
            }
        }
    }
    
    public var drawModel = YYDrawModel(){//当前的绘图模型
        didSet{
            self.yy_DrawModel(self.drawModel,addLines:true)
        }
    }
    var drawLineModel = YYDrawLineModel()//当前绘线的模型
    
    var deleteLineModel = [YYDrawLineModel]()
    
    var drawSettingView = YYSettingView(frame:CGRectMake(20,10,300,30))
    
    lazy var tableView : UITableView? = {
        return self.yy_tableView()
    }()
    
    convenience public init(frame: CGRect,lineColor:String) {
        self.init(frame: frame)
        //        self.drawSettingView.penOrEraseBtn.addTarget(self, action: "pen", forControlEvents: .TouchUpInside)
        //        self.drawSettingView.undoBtn.addTarget(self, action: "undo", forControlEvents: .TouchUpInside)
        //        self.drawSettingView.redoBtn.addTarget(self, action: "redo", forControlEvents: .TouchUpInside)
        //        self.drawSettingView.clearBtn.addTarget(self, action: "clear", forControlEvents: .TouchUpInside)
        //        self.drawSettingView.addHeightBtn.addTarget(self, action: "addHeight", forControlEvents: .TouchUpInside)
        //        self.addSubview(self.drawSettingView)
        self.lineColor = lineColor
        
        self.backgroundColor = UIColor.grayColor()
        self.clipsToBounds = true
    }
    
}

// MARK: - Touches Delegate
extension YYDrawView{
    //获取触摸点
    func pointWithTouches(touches:NSSet)->CGPoint?{
        let touch = touches.anyObject()
        return touch?.locationInView(self)
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.tableView != nil{
            self.tableView!.scrollEnabled = false
        }
        guard let startPoint = pointWithTouches(touches) else{return}
        guard let event = event else{return}
        guard let count = event.allTouches()?.count else{return}
        if count == 1{
            //新建一个保存线条的模型
            self.drawLineModel = YYDrawLineModel()
            self.drawLineModel.paintSize = NSNumber(float: Float(self.lineWidth))
            self.drawLineModel.paintColor = self.lineColor
            self.drawLineModel.isEraser = self.lineType
            self.drawLineModel.pointList.append(YYDrawPointModel(point: startPoint))
            self.drawModel.lines.append(self.drawLineModel)
            //绘制
            self.path = YYLinePath(startPoint: startPoint, lineWith:self.drawLineModel.paintSize.CGFloatValue())
            self.caLayer = CAShapeLayer()
            self.caLayer.path = self.path.CGPath
            self.caLayer.backgroundColor = UIColor.clearColor().CGColor
            self.caLayer.fillColor = UIColor.clearColor().CGColor
            self.caLayer.lineCap = kCALineCapRound
            self.caLayer.lineJoin = kCALineJoinRound
            if lineType == 0{
                self.caLayer.strokeColor = UIColor.yy_hexString(self.lineColor).CGColor
                self.caLayer.lineWidth = path.lineWidth
            }
            if lineType == 1{
                
                self.caLayer.strokeColor = self.backgroundColor!.CGColor
                //self.path.strokeWithBlendMode(CGBlendMode.Clear, alpha: 1.0)
                self.caLayer.lineWidth = 10
            }
            self.layer.addSublayer(self.caLayer)
            self.lines.append(self.caLayer)
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.tableView != nil{
            self.tableView!.scrollEnabled = false
        }
        guard let movePoint = pointWithTouches(touches) else{return}
        if movePoint.x < 0 || movePoint.x > self.frame.width || movePoint.y < 0 || movePoint.y > self.frame.height{
            self.touchesCancelled(nil, withEvent: nil)
            return
        }
        guard let event = event else{return}
        guard let count = event.allTouches()?.count else{return}
        if count == 1{
            //线条模型更新
            self.drawLineModel.pointList.append(YYDrawPointModel(point: movePoint))
            //绘制
            self.path.addLineToPoint(movePoint)
            self.caLayer.path = self.path.CGPath
        }else{
            self.superview?.touchesMoved(touches, withEvent: event)
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.tableView != nil{
            self.tableView!.scrollEnabled = true
        }
        guard let event = event else{return}
        guard let count = event.allTouches()?.count else{return}
        if count > 1{
            self.superview?.touchesEnded(touches, withEvent: event)
        }
        //回调
        self.drawModel.height = self.frame.size.height
        self.drawModel.width = self.frame.size.width
        self.drawLineCompletion?(self.drawModel)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if self.tableView != nil{
            self.tableView!.scrollEnabled = true
        }
        self.superview?.touchesCancelled(touches, withEvent: event)
        //回调
        self.drawModel.height = self.frame.size.height
        self.drawModel.width = self.frame.size.width
        self.drawLineCompletion?(self.drawModel)
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, withEvent: event){
            if view.isKindOfClass(YYDrawView.self){
                if self.tableView != nil{
                    self.tableView!.scrollEnabled = false
                }
            }
        }
        return super.hitTest(point, withEvent: event)
    }
    
}


// MARK: - 传入model后画线
extension YYDrawView{
    func yy_DrawModel(drawModel:YYDrawModel,addLines:Bool){
        let xScale = self.frame.size.width / drawModel.width.CGFloatValue()
        let yScale = self.frame.size.height / drawModel.height.CGFloatValue()
        
        for line in drawModel.lines{
            if line.pointList.count < 2{break}
            let path = YYLinePath(startPoint:CGPoint(x: line.pointList[0].x.CGFloatValue() * xScale, y: line.pointList[0].y.CGFloatValue() * yScale), lineWith:line.paintSize.CGFloatValue())
            let caLayer = CAShapeLayer()
            caLayer.path = self.path.CGPath
            caLayer.backgroundColor = UIColor.clearColor().CGColor
            caLayer.fillColor = UIColor.clearColor().CGColor
            caLayer.lineCap = kCALineCapRound
            caLayer.lineJoin = kCALineJoinRound
            if line.isEraser.boolValue{
                caLayer.strokeColor = self.backgroundColor!.CGColor
            }else{
                caLayer.strokeColor = UIColor.yy_hexString(line.paintColor).CGColor
            }
            caLayer.lineWidth = path.lineWidth
            self.layer.addSublayer(caLayer)
            
            //是否需要添加到数组里，这个数组是用来撤销回退的
            if addLines{
                lines.append(caLayer)
            }
            
            var points = line.pointList
            points.removeFirst()
            for point in points{
                path.addLineToPoint(CGPoint(x: point.x.CGFloatValue() * xScale, y: point.y.CGFloatValue() * yScale))
                caLayer.path = path.CGPath
            }
            
        }
    }
    
}

// MARK: - 清空，铅笔，橡皮，前进，回退，添加高度
public extension YYDrawView{
    //清屏
    public func clear(){
        for line in self.lines{
            line.removeFromSuperlayer()
        }
        self.lines.removeAll()
        self.drawModel.lines.removeAll()
        self.drawLineCompletion?(self.drawModel)
    }
    //铅笔 或 橡皮
    public func pen(){
        if self.lineType == 0{
            self.lineType = 1
            self.drawSettingView.penOrEraseBtn.setTitle("当前画笔", forState: .Normal)
            self.changeLineType?(true)
        }else{
            self.lineType = 0
            self.drawSettingView.penOrEraseBtn.setTitle("当前橡皮", forState: .Normal)
            self.changeLineType?(false)
        }
    }
    //前进
    public func redo(){
        if self.deleteLines.count < 1 || self.deleteLineModel.count < 1{return}
        self.lines.append(self.deleteLines.last!)
        self.drawModel.lines.append(self.deleteLineModel.last!)
        self.deleteLines.removeLast()
        self.deleteLineModel.removeLast()
        self.draw(self.lines.last!)
        self.drawLineCompletion?(self.drawModel)
        
    }
    
    //后退
    public func undo(){
        if self.lines.count < 1 || self.drawModel.lines.count < 1{return}
        self.deleteLineModel.append(self.drawModel.lines.last!)
        self.deleteLines.append(self.lines.last!)
        self.lines.last!.removeFromSuperlayer()
        self.lines.removeLast()
        self.drawModel.lines.removeLast()
        self.drawLineCompletion?(self.drawModel)
    }
    
    //添加高度
    public func addHeight(){
        let frame = self.frame
        let fra = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 100.0)
        self.frame = fra
        self.drawModel.height = self.drawModel.height.CGFloatValue() + 100
        self.addHeightCompletion?(self.drawModel)
        self.setNeedsLayout()
    }
    
    
    
    func draw(caLayer:CAShapeLayer){
        self.layer.addSublayer(caLayer)
    }
    
}
