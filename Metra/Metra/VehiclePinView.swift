//
//  VehiclePinView.swift
//  Metra
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class VehiclePinView: UIView {

    let color: UIColor

    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable line_length
    override func draw(_ rect: CGRect) {
        color.setFill()

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 92, y: 43.88))
        bezierPath.addCurve(to: CGPoint(x: 65.57, y: 84.5), controlPoint1: CGPoint(x: 92, y: 62.31), controlPoint2: CGPoint(x: 81.95, y: 78.01))
        bezierPath.addCurve(to: CGPoint(x: 48.32, y: 115.43), controlPoint1: CGPoint(x: 61.13, y: 86.26), controlPoint2: CGPoint(x: 53.98, y: 109.17))
        bezierPath.addCurve(to: CGPoint(x: 46.36, y: 116.89), controlPoint1: CGPoint(x: 47.64, y: 116.17), controlPoint2: CGPoint(x: 46.99, y: 116.68))
        bezierPath.addCurve(to: CGPoint(x: 46.26, y: 117), controlPoint1: CGPoint(x: 46.33, y: 116.96), controlPoint2: CGPoint(x: 46.3, y: 117))
        bezierPath.addCurve(to: CGPoint(x: 46, y: 116.98), controlPoint1: CGPoint(x: 46.17, y: 117), controlPoint2: CGPoint(x: 46.09, y: 116.99))
        bezierPath.addCurve(to: CGPoint(x: 45.74, y: 117), controlPoint1: CGPoint(x: 45.91, y: 116.99), controlPoint2: CGPoint(x: 45.83, y: 117))
        bezierPath.addCurve(to: CGPoint(x: 45.64, y: 116.89), controlPoint1: CGPoint(x: 45.7, y: 117), controlPoint2: CGPoint(x: 45.67, y: 116.96))
        bezierPath.addCurve(to: CGPoint(x: 43.68, y: 115.43), controlPoint1: CGPoint(x: 45.01, y: 116.68), controlPoint2: CGPoint(x: 44.36, y: 116.17))
        bezierPath.addCurve(to: CGPoint(x: 26.43, y: 84.5), controlPoint1: CGPoint(x: 38.02, y: 109.17), controlPoint2: CGPoint(x: 30.87, y: 86.26))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 43.88), controlPoint1: CGPoint(x: 10.05, y: 78.01), controlPoint2: CGPoint(x: 0, y: 62.31))
        bezierPath.addCurve(to: CGPoint(x: 13.47, y: 12.46), controlPoint1: CGPoint(x: 0, y: 31.56), controlPoint2: CGPoint(x: 5.16, y: 20.43))
        bezierPath.addCurve(to: CGPoint(x: 44.61, y: 0), controlPoint1: CGPoint(x: 21.51, y: 4.75), controlPoint2: CGPoint(x: 32.49, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 46, y: 0.02), controlPoint1: CGPoint(x: 45.09, y: 0), controlPoint2: CGPoint(x: 45.55, y: 0.01))
        bezierPath.addCurve(to: CGPoint(x: 47.39, y: 0), controlPoint1: CGPoint(x: 46.45, y: 0.01), controlPoint2: CGPoint(x: 46.91, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 92, y: 43.88), controlPoint1: CGPoint(x: 72.03, y: 0), controlPoint2: CGPoint(x: 92, y: 19.64))
        bezierPath.close()
        bezierPath.fill()

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2.5
        layer.shadowPath = bezierPath.cgPath
    }

}
