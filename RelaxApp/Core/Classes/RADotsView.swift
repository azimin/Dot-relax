//
//  RADotsView.swift
//  RelaxApp
//
//  Created by Alex Zimin on 21/12/14.
//  Copyright (c) 2014 alex. All rights reserved.
//

import UIKit


enum RADotsViewAlignment {
    case Greater, Less, Equal
}

class RADotsView: UIView {
    
    var spacesAlignment: RADotsViewAlignment = .Less {
        didSet {
            loadZones()
        }
    }
    
    @IBInspectable
    var spaceBetweenViews: CGFloat = 64 {
        didSet {
            loadZones()
        }
    }
    
    @IBInspectable
    var dotImage: UIImage? {
        didSet {
            loadZones()
        }
    }
    
    @IBInspectable
    var dotSize: CGFloat = defaultDotSize
    
    private var zones: [RADotZone] = []
    
    // MARK: - Init
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        loadZones()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadZones()
    }
    
    // MARK: - Alignment
    
    func calculateAlignment(length: CGFloat) -> (count: Int, space: CGFloat) {
        let number = length / spaceBetweenViews
        var finalNumber = Int(number)
        
        if spacesAlignment == .Equal {
            return (finalNumber, spaceBetweenViews)
        } else if spacesAlignment == .Greater {
            if CGFloat(finalNumber) == number {
                return (finalNumber, spaceBetweenViews)
            }
            
            finalNumber++
        }
        
        return (finalNumber, length / CGFloat (finalNumber))
    }
    
    // MARK: - Zones
    
    private func loadZones() {
        zones.map({ $0.removeFromSuperview() })
        zones.removeAll(keepCapacity: false)
        
        var widthInfo = calculateAlignment(self.frame.width)
        var heightInfo = calculateAlignment(self.frame.height)
        
        for row in 0..<widthInfo.count {
            for column in 0..<heightInfo.count {
                var frame = CGRectMake(CGFloat(row) * widthInfo.space, CGFloat(column) * heightInfo.space, widthInfo.space, heightInfo.space)
                let zone = RADotZone(frame: frame, color: nil, selectedColor: nil)
                
                zone.userInteractionEnabled = false
                zone.dotImage = dotImage
                zone.dotSize = dotSize
                
                self.addSubview(zone)
                zones.append(zone)
            }
        }
    }
    
    // MARK: - Touch
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = event.allTouches()?.anyObject() as? UITouch ?? UITouch()
        let location = touch.locationInView(self)
        
        for zone in zones {
            if CGRectContainsPoint(zone.frame, location) {
                zone.touchesMoved(touches, withEvent: event)
            } else {
                zone.touchesEnded(touches, withEvent: event)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for zone in zones {
            zone.touchesEnded(touches, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }
}






