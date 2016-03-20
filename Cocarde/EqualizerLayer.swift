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
  
  var plotMinScale: CGFloat = 0.2
  var plotGapSize: CGFloat  = 0
  
  required init(segmentCount segments: UInt, segmentColors colors: [UIColor], loopDuration duration: Double) {
    super.init(segmentCount: segments, segmentColors: colors, loopDuration: duration)
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Drawing Cocarde Activity
  
  override func drawInRect(rect: CGRect) {
    let center     = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
    let colorCount = segmentColors.count
    
    let plotHeight    = min(CGRectGetWidth(rect), CGRectGetHeight(rect))
    let plotMinHeight = plotHeight * plotMinScale
    let plotWidth     = CGRectGetWidth(rect) / CGFloat(segmentCount)

    for i in 0 ..< segmentCount {
      var values: [CGPath] = []
      let initialHeight     = plotHeight * plotMinScale + CGFloat(arc4random_uniform(UInt32(plotHeight - plotMinHeight)))
      let plotRect          = CGRectMake(0, 0, plotWidth - plotGapSize, -initialHeight)

      for _ in 0 ..< 10 {
        let randomHeight = plotHeight * plotMinScale + CGFloat(arc4random_uniform(UInt32(plotHeight - plotMinHeight)))
        let randomRect   = CGRectMake(0, 0, plotRect.width, -randomHeight)

        values.append(UIBezierPath(rect: randomRect).CGPath)
      }
      
      values.insert(UIBezierPath(rect: plotRect).CGPath, atIndex: 0)
      values.append(UIBezierPath(rect: plotRect).CGPath)

      let plotLayer = CAShapeLayer()
      addSublayer(plotLayer)
      
      plotLayer.path        = UIBezierPath(rect: plotRect).CGPath
      plotLayer.fillColor   = segmentColors[Int(i) % colorCount].CGColor
      plotLayer.strokeColor = plotLayer.fillColor
      plotLayer.position    = CGPointMake(center.x - CGRectGetWidth(rect) / 2 + plotWidth * CGFloat(i) + plotGapSize / 2, CGRectGetMaxY(rect))
      plotLayer.anchorPoint = CGPointMake(0.5, 0)
      
      let anim                 = CAKeyframeAnimation(keyPath: "path")
      anim.duration            = loopDuration
      anim.cumulative          = false
      anim.repeatCount         = Float.infinity
      anim.fillMode            = kCAFillModeForwards
      anim.values              = values
      anim.removedOnCompletion = false
      
      plotLayer.addAnimation(anim, forKey: "plot.path")
    }
  }
}
