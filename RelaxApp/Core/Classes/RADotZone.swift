//
//  RADotZone.swift
//  RelaxApp
//
//  Created by Alex Zimin on 21/12/14.
//  Copyright (c) 2014 alex. All rights reserved.
//

import UIKit

private let defaultDotSize: CGFloat = 8

class RADotZone: UIView {
    
    // MARK: - Default
    
    @IBInspectable
    var color: UIColor = UIColor.colorWithHexString("808080") {
        didSet {
            dot.backgroundColor = color
        }
    }
    
    @IBInspectable
    var selectedColor: UIColor = UIColor.darkGrayColor()
    
    @IBInspectable
    var dotSize: CGFloat = defaultDotSize {
        didSet {
            dot.frame = CGRectMake(0, 0, dotSize, dotSize)
            dot.layer.cornerRadius = dotSize / 2
            dot.center = centerOnView
        }
    }
    
    private var dot: UIView = {
        let dot = UIView(frame: CGRectMake(0, 0, defaultDotSize, defaultDotSize))
        dot.layer.cornerRadius = dot.frame.width / 2
    
        return dot
    }()
    
    // MARK: - Init
    
    init(frame: CGRect, color: UIColor?, selectedColor: UIColor?) {
        super.init(frame: frame)
        
        self.color = color ?? self.color
        self.selectedColor = selectedColor ?? self.selectedColor
        
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        dot.center = centerOnView
        dot.backgroundColor = color
        
        self.addSubview(self.dot)
    }
    
    // MARK: - Position
    
    private var centerOnView: CGPoint {
        return CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    // MARK: - Animation
    
    @IBInspectable
    var speed: Double = 0.4
    
    @IBInspectable
    var bouncing: Double = 1.0
    
    @IBInspectable
    var zooming: Double = 2.0
    
    // MARK: - Touch
    
    private var isMoving: Bool = false
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        touchesMoved(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = event.allTouches()?.anyObject() as? UITouch ?? UITouch()
        let location = touch.locationInView(self)
        
        if !CGRectContainsPoint(self.bounds, location) {
            touchesEnded(touches, withEvent: event)
            return
        }
        
        isMoving = true
        
        var currentSpeed = Double(hypot(dot.center.x - location.x, dot.center.y - location.y) / self.frame.width)
        var zoom = CGFloat(currentSpeed * zooming) + CGFloat(zooming)
        
        UIView.animateWithDuration(currentSpeed * speed, animations: { () -> Void in
            self.dot.center = location
            self.dot.transform = CGAffineTransformScale(CGAffineTransformIdentity, zoom, zoom);
            self.dot.backgroundColor = self.selectedColor
        })
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if !isMoving {
            return
        }
        
        var currentSpeed = Double(hypot(dot.center.x - centerOnView.x, dot.center.y - centerOnView.y) / self.frame.width)
        
        
        UIView.animateWithDuration(currentSpeed * speed * 4,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: .CurveEaseInOut,
            animations:
            {
                self.dot.center = self.centerOnView
                self.dot.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.dot.backgroundColor = self.color
            },
            completion: {success in })
        
        isMoving = false
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }

}
