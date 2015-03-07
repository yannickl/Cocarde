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

final class PieLayer: CocardeLayer {
  var plotScaleDuration: Double = 4.0
  var plotMinScale: CGFloat     = 0.9
  var plotMaxScale: CGFloat     = 1.2
  
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
    let radius     = (min(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2) / plotMaxScale
    let colorCount = segmentColors.count

    for i in 0 ..< segmentCount {
      let startAngle = CGFloat(i) * angle
      let endAngle   = startAngle + angle

      let plotLayer = CAShapeLayer()
      addSublayer(plotLayer)
      
      let plotPath = UIBezierPath()
      plotPath.moveToPoint(CGPointZero)
      plotPath.addArcWithCenter(CGPointZero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      plotLayer.path        = plotPath.CGPath
      plotLayer.fillColor   = segmentColors[Int(i) % colorCount].CGColor
      plotLayer.strokeColor = plotLayer.fillColor
      plotLayer.position    = center
      
      let anim            = CAKeyframeAnimation(keyPath: "transform.scale")
      anim.duration       = plotScaleDuration
      anim.cumulative     = false
      anim.repeatCount    = Float.infinity
      anim.values         = [plotMinScale, plotMaxScale, plotMinScale]
      anim.timeOffset     = (plotScaleDuration / 4) * Double(i % 4)
      anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      plotLayer.addAnimation(anim, forKey: "plot.scale")
    }
    
    let anim          = CABasicAnimation(keyPath:"transform.rotation.z")
    anim.duration     = loopDuration
    anim.fromValue    = 0
    anim.toValue      = 2 * M_PI
    anim.repeatCount  = Float.infinity
    anim.autoreverses = false

    addAnimation(anim, forKey: "self.rotation")
  }
}
