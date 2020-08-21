//
//  DropdownBackgroundView.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import UIKit

class DropdownBackgroundView: UIView {
    
    var arrowPoint: CGPoint = .zero
    var arrowDirection: DropdownPresentationController.ArrowDirection = .up
    var configuration: DropdownConfiguration = DropdownConfiguration.shared
    var arrowColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            let fillColor = self.arrowColor ?? UIColor.white
            
            context.saveGState()
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            let trianglePath = UIBezierPath()
            
            let startX: CGFloat = arrowPoint.x
            let startY: CGFloat = arrowPoint.y
            let triangleHeight: CGFloat = self.configuration.arrowSize.height
            let triangleWidth: CGFloat = self.configuration.arrowSize.width
            let halfWidth = triangleWidth / 2
            
            switch self.arrowDirection {
            case .up:
                let triangleStartY: CGFloat = 0
                trianglePath.move(to: CGPoint(x: startX, y: triangleStartY))
                trianglePath.addLine(to: CGPoint(x: startX + halfWidth, y: triangleStartY + triangleHeight))
                trianglePath.addLine(to: CGPoint(x: startX - halfWidth, y: triangleStartY + triangleHeight))
            case .down:
                let triangleStartY = rect.height - triangleHeight
                trianglePath.move(to: CGPoint(x: startX, y: rect.height))
                trianglePath.addLine(to: CGPoint(x: startX + halfWidth, y: triangleStartY))
                trianglePath.addLine(to: CGPoint(x: startX - halfWidth, y: triangleStartY))
            case .right:
                trianglePath.move(to: CGPoint(x: rect.width, y: startY))
                trianglePath.addLine(to: CGPoint(x: rect.width - triangleHeight, y: startY - halfWidth))
                trianglePath.addLine(to: CGPoint(x: rect.width - triangleHeight, y: startY + halfWidth))
            case .left:
                trianglePath.move(to: CGPoint(x: 0, y: startY))
                trianglePath.addLine(to: CGPoint(x: triangleHeight, y: startY - halfWidth))
                trianglePath.addLine(to: CGPoint(x: triangleHeight, y: startY + halfWidth))
            }
            
            trianglePath.miterLimit = 4
            trianglePath.usesEvenOddFillRule = true
            
            fillColor.setFill()
            trianglePath.fill()
            
            let roundedRect: CGRect
            switch self.arrowDirection {
            case .up:
                roundedRect = CGRect(x: 0, y: triangleHeight, width: rect.width, height: rect.height - triangleHeight)
            case .down:
                roundedRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height - triangleHeight)
            case .right:
                roundedRect = CGRect(x: 0, y: 0, width: rect.width - triangleHeight, height: rect.height)
            case .left:
                roundedRect = CGRect(x: triangleHeight, y: 0, width: rect.width - triangleHeight, height: rect.height)
            }
            
            let rectanglePath = UIBezierPath(roundedRect: roundedRect, cornerRadius: self.configuration.cornerRadius)
            fillColor.setFill()
            rectanglePath.fill()
            
            context.endTransparencyLayer()
            context.restoreGState()
        }
    }
}
