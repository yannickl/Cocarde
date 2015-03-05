/*
* Cocarde
*
* Copyright 2015-present Yannick Loriot.
* http://yannickloriot.com
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import Foundation
import UIKit
import QuartzCore

final class DefaultLayer: CocardeLayer {
  var plotMinScale: CGFloat = 0.9
  var plotMaxScale: CGFloat = 1.2
  
  required init(segmentCount segments: UInt, segmentColors colors: [UIColor], loopDuration duration: Double) {
    super.init(segmentCount: segments, segmentColors: colors, loopDuration: duration)
  }
  
  override init!(layer: AnyObject!) {
    super.init(layer: layer)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Drawing Cocarde Activity
  
  override func drawInRect(rect: CGRect) {
    let center     = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
    let angle      = CGFloat(2 * M_PI / Double(segmentCount))
    let colorCount = segmentColors.count
    
    let radius     = (min(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2) / plotMaxScale / CGFloat(segmentCount)
    let startAngle = CGFloat(0)
    let endAngle   = CGFloat(2 * M_PI)
    
    for i in 0 ..< segmentCount {
      let circleRadius = radius * CGFloat(i)
      let plotLayer = CAShapeLayer()
      insertSublayer(plotLayer, atIndex: 0)
      
      let plotPath = UIBezierPath()
      plotPath.addArcWithCenter(CGPointZero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      plotLayer.path      = plotPath.CGPath
      plotLayer.fillColor = segmentColors[Int(i) % colorCount].CGColor
      plotLayer.position  = center
      plotLayer.speed     = 0
      
      var scaleValues: [CGFloat] = []
      
      for j in 0 ..< segmentCount {
        if i == j {
          scaleValues.append(plotMaxScale)
        }
        else {
          scaleValues.append(0)
        }
      }
      
      let anim            = CAKeyframeAnimation(keyPath: "transform.scale")
      anim.duration       = loopDuration
      anim.cumulative     = false
      anim.repeatCount    = Float.infinity
      anim.values         = scaleValues
      //anim.timeOffset     = (loopDuration / Double(segmentCount)) * Double(i)
      anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      plotLayer.addAnimation(anim, forKey: "plot.scale")
    }
  }
}
