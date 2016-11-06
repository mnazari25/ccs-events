//
//  Animations.swift
//  VPN-WL-iOS
//
//  Created by Amir Nazari on 10/26/16.
//  Copyright © 2016 Mudhook Marketing. All rights reserved.
//

import Foundation
import GLKit

var circleProgressLineLayer = CAShapeLayer()
var checkmarkLayer = CAShapeLayer()
var crossLayer = CAShapeLayer()

class Animations {
    /// Spinning circle
    static func animateIndeterminateDialog(progressView : UIView) {
        setupInfiniteCircle(progressView: progressView)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = -(M_PI * 2.0 * 1.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        progressView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    static func setupInfiniteCircle(progressView : UIView, lineWidth : CGFloat = 2.0) {
        let circleRadius: CGFloat = progressView.frame.width / 2.0
        let centerPoint = CGPoint(x: circleRadius, y: circleRadius)
        let circlePath = UIBezierPath(arcCenter: centerPoint,
                                      radius: (circleRadius - lineWidth),
                                      startAngle: CGFloat(GLKMathDegreesToRadians(20.0)),
                                      endAngle: CGFloat(GLKMathDegreesToRadians(320.0)),
                                      clockwise: true)
        
        circleProgressLineLayer.path = circlePath.cgPath
        circleProgressLineLayer.strokeColor = UIColor.white.cgColor
        circleProgressLineLayer.fillColor = nil
        circleProgressLineLayer.lineWidth = lineWidth
        
        progressView.layer.addSublayer(circleProgressLineLayer)
        circleProgressLineLayer.removeAllAnimations()
        progressView.layer.removeAllAnimations()
    }
    
    /// Checkmark
    static func checkMarkAnimation(progressView : UIView , lineWidth : CGFloat = 2.0, color : UIColor = .green, encryptionType: Int) {
        
        // AES 256 (secure) encryption type == 0
        // AES 128 (fast) encryption type == 1
        // check encryption type to choose which animation to display.
        if encryptionType == 1 {
            setupFastUI(progressView: progressView, lineWidth: lineWidth, color : color)
        } else {
            setupSuccessUI(progressView: progressView, lineWidth: lineWidth, color : color)
        }
    }
    
    static func setupSuccessUI(progressView : UIView, lineWidth : CGFloat = 2.0,color : UIColor = .green) {
        setupInfiniteCircle(progressView : progressView, lineWidth: lineWidth)
        
        let circleRadius: CGFloat = progressView.frame.width / 2.0
        let centerPoint = CGPoint(x: circleRadius, y: circleRadius)
        let circlePath = UIBezierPath()
        
        let scaleMultiplier = progressView.frame.width / 400
        
        circleProgressLineLayer.lineCap = kCALineCapRound
        circleProgressLineLayer.lineJoin = kCALineJoinRound
        
        circlePath.move(to: CGPoint(x: circleRadius - (60 * scaleMultiplier), y: circleRadius - (40 * scaleMultiplier)))
        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (60 * scaleMultiplier), y: circleRadius + (40 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (160 * scaleMultiplier), y: circleRadius - (0 * scaleMultiplier)))
        circlePath.move(to: CGPoint(x: circleRadius + (40 * scaleMultiplier), y: circleRadius - (40 * scaleMultiplier)))
        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (40 * scaleMultiplier), y: circleRadius + (40 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (60 * scaleMultiplier), y: circleRadius - (0 * scaleMultiplier)))
        
        circleProgressLineLayer.path = circlePath.cgPath
        
        progressView.layer.addSublayer(circleProgressLineLayer)
        
        progressView.layer.removeAllAnimations()
        circleProgressLineLayer.removeAllAnimations()
        
        animateSuccess(progressView : progressView, color : color)
    }
    
    static func setupFullCircle(progressView : UIView, lineWidth: CGFloat = 2.0, color : UIColor = .green) {
        let circleRadius: CGFloat = progressView.frame.height / 2.0
        let centerPoint = CGPoint(x: circleRadius, y: circleRadius)
        let circlePath = UIBezierPath(arcCenter: centerPoint,
                                      radius: (circleRadius - lineWidth),
                                      startAngle: CGFloat(GLKMathDegreesToRadians(-90.0)),
                                      endAngle: CGFloat(GLKMathDegreesToRadians(275.0)),
                                      clockwise: true)
        
        circleProgressLineLayer = CAShapeLayer()
        circleProgressLineLayer.path = circlePath.cgPath;
        circleProgressLineLayer.strokeColor = color.cgColor;
        circleProgressLineLayer.fillColor = UIColor.clear.cgColor
        circleProgressLineLayer.lineWidth = 2.0;
    }
    
    static func animateSuccess(progressView : UIView, color : UIColor = .green) {
        animateFullCircle(progressView : progressView, color: color)
        
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.duration = 0.7
        checkmarkAnimation.isRemovedOnCompletion = false
        checkmarkAnimation.fillMode = kCAFillModeBoth
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.toValue = 1
        checkmarkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        circleProgressLineLayer.add(checkmarkAnimation, forKey: "strokeEnd")
    }
    
    static func animateFullCircle(progressView : UIView, color : UIColor = .green) {
        let circleAnimation = CABasicAnimation(keyPath: "strokeColor")
        circleAnimation.duration = 0.5
        circleAnimation.isRemovedOnCompletion = false
        circleAnimation.fillMode = kCAFillModeBoth
        circleAnimation.toValue = color.cgColor
        
        circleProgressLineLayer.add(circleAnimation, forKey: "appearance")
    }
    
    /// Error 'X'
    static func errorXanimation(progressView : UIView) {
        setupFullCircle(progressView: progressView, color: .red)
        
        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: (progressView.frame.width * 0.72),
                                   y: (progressView.frame.height * 0.27)))
        crossPath.addLine(to: CGPoint(x: (progressView.frame.width * 0.27),
                                      y: (progressView.frame.height * 0.72)))
        crossPath.move(to: CGPoint(x: (progressView.frame.width * 0.27),
                                   y: (progressView.frame.height * 0.27)))
        crossPath.addLine(to: CGPoint(x: (progressView.frame.width * 0.72),
                                      y: (progressView.frame.height * 0.72)))
        
        crossLayer = CAShapeLayer()
        crossLayer.path = crossPath.cgPath
        crossLayer.fillColor = nil
        crossLayer.strokeColor = UIColor.red.cgColor
        crossLayer.lineWidth = 2.0
        
        progressView.layer.addSublayer(circleProgressLineLayer)
        progressView.layer.addSublayer(crossLayer)
        
        circleProgressLineLayer.removeAllAnimations()
        progressView.layer.removeAllAnimations()
        crossLayer.removeAllAnimations()
        
        animateError(progressView: progressView)
    }
    
    static func animateError(progressView : UIView) {
        animateFullCircle(progressView: progressView, color: .red)
    }
    
    /// Fast animation
    static func fastAnimation(progressView : UIView,lineWidth : CGFloat = 2.0, color : UIColor = .green) {
        setupFastUI(progressView: progressView, lineWidth: lineWidth, color: color)
    }
    
    static func setupFastUI(progressView : UIView, lineWidth : CGFloat = 2.0,color : UIColor = .green) {
        setupInfiniteCircle(progressView : progressView, lineWidth: lineWidth)
        
        let circleRadius: CGFloat = progressView.frame.width / 2.0
        let centerPoint = CGPoint(x: circleRadius, y: circleRadius)
        let circlePath = UIBezierPath()
        
        let scaleMultiplier = progressView.frame.width / 68
        
        circleProgressLineLayer.lineCap = kCALineCapRound
        circleProgressLineLayer.lineJoin = kCALineJoinRound
        
        /// RIP Harambe
        //        circlePath.move(to: CGPoint(x: circleRadius - (117 * scaleMultiplier), y: circleRadius - (6 * scaleMultiplier)))
        //        circlePath.addLine(to: CGPoint(x: circleRadius - (88 * scaleMultiplier), y: circleRadius - (47 * scaleMultiplier)))
        //        circlePath.addLine(to: CGPoint(x: circleRadius - (30 * scaleMultiplier), y: circleRadius - (77 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (32 * scaleMultiplier), y: circleRadius - (72 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (3 * scaleMultiplier), y: circleRadius - (129 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (60 * scaleMultiplier), y: circleRadius - (40 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (53 * scaleMultiplier), y: circleRadius - (62 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (90 * scaleMultiplier), y: circleRadius + (17 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (67 * scaleMultiplier), y: circleRadius - (17 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (110 * scaleMultiplier), y: circleRadius + (50 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (107 * scaleMultiplier), y: circleRadius + (27 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (118 * scaleMultiplier), y: circleRadius + (90 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (116 * scaleMultiplier), y: circleRadius + (68 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (95 * scaleMultiplier), y: circleRadius + (95 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (113 * scaleMultiplier), y: circleRadius + (98 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (66 * scaleMultiplier), y: circleRadius + (86 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (74 * scaleMultiplier), y: circleRadius + (99 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (51 * scaleMultiplier), y: circleRadius + (51 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (67 * scaleMultiplier), y: circleRadius + (64 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (38 * scaleMultiplier), y: circleRadius + (6 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (45 * scaleMultiplier), y: circleRadius + (32 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (7 * scaleMultiplier), y: circleRadius + (67 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (26 * scaleMultiplier), y: circleRadius + (36 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius + (38 * scaleMultiplier), y: circleRadius + (100 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (38 * scaleMultiplier), y: circleRadius + (71 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (40 * scaleMultiplier), y: circleRadius + (104 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius + (2 * scaleMultiplier), y: circleRadius + (108 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (41 * scaleMultiplier), y: circleRadius + (120 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (30 * scaleMultiplier), y: circleRadius + (112 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (91 * scaleMultiplier), y: circleRadius + (107 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (60 * scaleMultiplier), y: circleRadius + (117 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (98 * scaleMultiplier), y: circleRadius + (71 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (90 * scaleMultiplier), y: circleRadius + (86 * scaleMultiplier)))
        //        circlePath.addQuadCurve(to: CGPoint(x: circleRadius - (95 * scaleMultiplier), y: circleRadius + (30 * scaleMultiplier)), controlPoint: CGPoint(x: circleRadius - (100 * scaleMultiplier), y: circleRadius + (54 * scaleMultiplier)))
        //        circlePath.addLine(to: CGPoint(x: circleRadius - (106 * scaleMultiplier), y: circleRadius + (39 * scaleMultiplier)))
        //            circlePath.close()
        
        circlePath.move(to: CGPoint(x: circleRadius + (12 * scaleMultiplier),
                                    y: circleRadius - (9 * scaleMultiplier)))
        circlePath.addLine(to: CGPoint(x: circleRadius + (6 * scaleMultiplier),
                                       y: circleRadius - (3 * scaleMultiplier)))
        circlePath.addLine(to: CGPoint(x: circleRadius + (18 * scaleMultiplier),
                                       y: circleRadius - (3 * scaleMultiplier)))
        circlePath.addLine(to: CGPoint(x: circleRadius - (14 * scaleMultiplier),
                                       y: circleRadius + (20 * scaleMultiplier)))
        circlePath.addLine(to: centerPoint)
        circlePath.addLine(to: CGPoint(x: circleRadius - (10 * scaleMultiplier),
                                       y: circleRadius))
        circlePath.addLine(to: CGPoint(x: circleRadius + (21 * scaleMultiplier),
                                       y: circleRadius - (26 * scaleMultiplier)))
        circlePath.addArc(withCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(GLKMathDegreesToRadians(309.0)), endAngle: CGFloat(GLKMathDegreesToRadians(355.0)), clockwise: false)
        
        circleProgressLineLayer.path = circlePath.cgPath
        
        progressView.layer.addSublayer(circleProgressLineLayer)
        
        progressView.layer.removeAllAnimations()
        circleProgressLineLayer.removeAllAnimations()
        
        animateSuccess(progressView : progressView, color : color)
    }
}

