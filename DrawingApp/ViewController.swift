//
//  ViewController.swift
//  DrawingApp
//
//  Created by Pang on 2018. 4. 3..
//  Copyright © 2018년 HwangByungJo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue : CGFloat = 0.0
    var brushWidth : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClickReset(_ sender: Any) {
         mainImageView.image = nil
    }
    
    @IBAction func onClickSetting(_ sender: Any) {
        
        
    }
    
    @IBAction func onClickColor(_ btn: UIButton) {
        
        if let color = btn.backgroundColor{
            
            red = color.redValue
            green = color.greenValue
            blue = color.blueValue
        }
        if btn.backgroundColor == UIColor.white {
            
            opacity = 1.0
        }
    }
    @IBAction func onClickSave(_ sender: Any) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(view.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), blendMode: .normal, alpha: 1)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

