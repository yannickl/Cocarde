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

internal final class EqualizerLayer: CocardeLayer {
  override var hideAnimationDefaultKeyPath: String {
    get {
      return "transform.scale.y"
    }
  }
  
  var plotMinScale: CGFloat = 0.4
  var plotMaxScale: CGFloat = 1.0
  var plotGapSize: CGFloat  = 10
  
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
    
    let plotHeight = min(CGRectGetWidth(rect), CGRectGetHeight(rect)) / plotMaxScale
    let plotWidth  = CGRectGetWidth(rect) / CGFloat(segmentCount)
    
    // Prepare plot scale values
    var values: [CGFloat] = []
    
    for i in 0 ..< segmentCount {
      let plotScale = (plotMaxScale - plotMinScale) * CGFloat(sin(M_PI / Double(segmentCount) * Double(i)))
      
      values.append(plotMinScale + plotScale)
    }
    
    for i in 0 ..< 1 {
      values.insert(plotMinScale, atIndex: 0)
      values.append(plotMinScale)
    }

    for i in 0 ..< segmentCount {
      let startAngle = CGFloat(i) * angle
      let endAngle   = startAngle + angle
      
      let plotLayer = CAShapeLayer()
      addSublayer(plotLayer)
      
      let plotRect = CGRectMake(-CGRectGetWidth(rect) / 2 + plotWidth * CGFloat(i) + plotGapSize / 2, -plotHeight / 2, plotWidth - plotGapSize, plotHeight)

      plotLayer.path        = UIBezierPath(rect: plotRect).CGPath
      plotLayer.fillColor   = segmentColors[Int(i) % colorCount].CGColor
      plotLayer.strokeColor = plotLayer.fillColor
      plotLayer.position    = center
      
      let anim                 = CAKeyframeAnimation(keyPath: "transform.scale.y")
      anim.duration            = loopDuration
      anim.cumulative          = false
      anim.repeatCount         = Float.infinity
      anim.values              = values
      anim.timeOffset          = loopDuration - (loopDuration / CFTimeInterval(segmentCount) * CFTimeInterval(i))
      anim.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      anim.removedOnCompletion = false
      plotLayer.addAnimation(anim, forKey: "plot.scale")
    }
  }
}
