//
//  UnitCircleView.swift
//  iMathTutor
//
//  Created by Keith on 12/08/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

@IBDesignable
class UnitCircleView: UIView {
    
    @IBInspectable var showUnitCircle = true
    @IBInspectable var showThumb = true
    @IBInspectable var showAxes = true
    @IBInspectable var showRadial = true
    @IBInspectable var showThumbCoordinateLines = true
    @IBInspectable var showAngle = true
    @IBInspectable var thetaDegrees: Double = 0.0 {
        didSet {
            updateLabels()
            self.setNeedsDisplay()
        }
    }
    var theta : Double {
        return Double.pi * thetaDegrees / 180.0
    }
    
    var xValueHConstraint: NSLayoutConstraint? = nil
    var yValueVConstraint: NSLayoutConstraint? = nil
    var angleHConstraint: NSLayoutConstraint? = nil
    var angleVConstraint: NSLayoutConstraint? = nil
    
    let s = CGFloat(1000.0)
    var sD: Double { return Double(s) }
    let sPlus = CGFloat(1200.0)
    
    override func didMoveToWindow() {
        updateLabels()
    }
    
    func updateLabels() {
        xValue.text = "x = " + numberFormatter.string(from: NSNumber(value: cos(self.theta)))!
        let xlabelPoint = angleToViewPoint()
        xValueHConstraint?.constant = xlabelPoint.x
        
        yValue.text = "y = " + numberFormatter.string(from: NSNumber(value: sin(self.theta)))!
        let ylabelPoint = angleToViewPoint()
        yValueVConstraint?.constant = ylabelPoint.y
        
        angleValue.text = angleFormatter.string(from: NSNumber(value: thetaDegrees))
        let anglePoint = angleToViewPoint(alpha: theta/2.0)
        angleHConstraint?.constant = 1.15 * anglePoint.x
        angleVConstraint?.constant = 1.15 * anglePoint.y
        
        layoutSubviews()
    }
    
    func angleToViewPoint(alpha: Double? = nil) -> CGPoint {
        let beta = alpha ?? theta
        let r = Double(s * sf)
        return CGPoint(x: r * cos(beta), y: -r * sin(beta))
    }
    
    lazy var angleValue: UITextField = {
        let field = UITextField()
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.backgroundColor = UIColor.green
        addSubview(field)
        field.text = "-000"
        field.textColor = UIColor.red
        angleHConstraint = field.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        angleHConstraint?.isActive = true
        angleVConstraint = field.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        angleVConstraint?.isActive = true
        field.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: .bold)
        field.sizeToFit()
        field.textAlignment = .center
        field.widthAnchor.constraint(equalToConstant: field.frame.size.width).isActive = true
        return field
    }()
    
    lazy var xValue: UITextField = {
        let field = UITextField()
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.backgroundColor = UIColor.black
        addSubview(field)
        field.text = "X = -00.000"
        field.textColor = UIColor.white
        xValueHConstraint = field.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        xValueHConstraint?.isActive = true
        field.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 4).isActive = true
        field.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: .bold)
        field.sizeToFit()
        field.textAlignment = .center
        field.widthAnchor.constraint(equalToConstant: field.frame.size.width).isActive = true
        return field
    }()
    
    lazy var yValue: UITextField = {
        let field = UITextField()
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.backgroundColor = UIColor.black
        addSubview(field)
        field.text = "Y = -00.000"
        field.textColor = UIColor.white
        yValueVConstraint = field.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        yValueVConstraint?.isActive = true
        field.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -4).isActive = true
        field.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: .bold)
        field.sizeToFit()
        field.textAlignment = .center
        field.widthAnchor.constraint(equalToConstant: field.frame.size.width).isActive = true
        return field
    }()
    
    lazy var numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 3
        nf.maximumFractionDigits = 3
        return nf
    }()
    
    lazy var angleFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    override func draw(_ rect: CGRect) {
        UIColor.green.setFill()
        UIRectFill(bounds)
        drawAxes()
        drawUnitCircle()
        drawRadial()
        drawThumbCoordinateLines()
        drawAngle()
        drawThumb()
    }
    
    func drawAngle() {
        guard showAngle else { return }
        let p: UIBezierPath
        if theta >= 0 {
            p = UIBezierPath(arcCenter: CGPoint(x:0,y:0), radius: s, startAngle: 0.0, endAngle: CGFloat(theta), clockwise: true)
        } else {
            p = UIBezierPath(arcCenter: CGPoint(x:0,y:0), radius: s, startAngle: 0.0, endAngle: CGFloat(theta), clockwise: false)
        }
        
        p.lineWidth = 4
        UIColor.red.setStroke()
        p.apply(drawTransform())
        p.stroke()
    }
    
    func drawThumbCoordinateLines() {
        guard showThumbCoordinateLines else { return }
        UIColor.white.setStroke()
        let p = UIBezierPath()
        p.move(to: CGPoint(x: sD * cos(theta), y: 0))
        p.addLine(to: thumbPoint)
        p.move(to: CGPoint(x: 0, y: sD * sin(theta)))
        p.addLine(to: thumbPoint)
        p.apply(drawTransform())
        p.lineWidth = 2
        p.setLineDash([8.0,4.0], count: 2, phase: 0)
        p.stroke()
    }
    
    func drawRadial() {
        guard showRadial else { return }
        UIColor.lightGray.setStroke()
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: thumbPoint)
        p.apply(drawTransform())
        p.lineWidth = 4
        p.stroke()
    }
    
    
    func drawAxes() {
        guard showAxes else { return }
        UIColor.lightGray.setStroke()
        let p = UIBezierPath()
        p.move(to: CGPoint(x: -sPlus, y: 0))
        p.addLine(to: CGPoint(x: sPlus, y: 0))
        p.move(to: CGPoint(x: 0, y: -sPlus))
        p.addLine(to: CGPoint(x: 0, y: sPlus))
        p.apply(drawTransform())
        p.lineWidth = 4
        p.stroke()
    }
    
    func drawUnitCircle() {
        guard showUnitCircle else { return }
        UIColor.white.setStroke()
        let p = UIBezierPath(ovalIn: CGRect(x: -s, y: -s, width: 2*s, height: 2*s))
        p.apply(drawTransform())
        p.lineWidth = 2
        p.stroke()
    }
    
    func drawThumb() {
        guard showThumb else { return }
        UIColor.white.setStroke()
        UIColor.white.setFill()
        let p = UIBezierPath(ovalIn: thumbBox)
        p.apply(drawTransform())
        p.lineWidth = 8
        p.fill()
    }
    
    var thumbPoint: CGPoint {
        return CGPoint(x: sD*cos(theta), y: sD*sin(theta))
    }
    
    var thumbBox: CGRect {
        let w = CGFloat(50)
        return CGRect(x: thumbPoint.x-w, y: thumbPoint.y-w, width: 2*w, height: 2*w)
    }
    
    var halfSize: CGFloat {
        return min(bounds.width/2.0, bounds.height/2.0)
    }
    
    var sf: CGFloat {
        return halfSize/sPlus
    }
    
    func drawTransform() -> CGAffineTransform {
        let t = CGAffineTransform.init(translationX: sPlus, y: -sPlus)
        let scale = CGAffineTransform.init(scaleX: sf, y: -sf)
        return t.concatenating(scale)
    }
    
    

}
