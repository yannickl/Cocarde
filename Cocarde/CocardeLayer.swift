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

internal class CocardeLayer: CALayer {
  let segmentCount: UInt
  let segmentColors: [UIColor]
  let rotationDuration: Double
  
  override var frame: CGRect {
    didSet {
      clearDrawing()
      
      drawInRect(bounds)
    }
  }
  
  required init(segmentCount segments: UInt, segmentColors colors: [UIColor], rotationDuration duration: Double) {
    segmentCount     = segments
    segmentColors    = colors
    rotationDuration = duration
    
    super.init()
  }
  
  override init!(layer: AnyObject!) {
    if layer is PieLayer {
      segmentCount     = layer.segmentCount
      segmentColors    = layer.segmentColors
      rotationDuration = layer.rotationDuration
    }
    else {
      fatalError("init(coder:) has not been implemented")
    }
    
    super.init(layer: layer)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setNeedsDisplay() {
    super.setNeedsDisplay()
    
    clearDrawing()
    drawInRect(bounds)
  }
  
  // MARK: - Drawing Cocarde Activity
  
  internal func clearDrawing() {
    if sublayers != nil {
      for layer in sublayers {
        layer.removeAllAnimations()
        layer.removeFromSuperlayer()
      }
    }
    
    removeAllAnimations()
  }
  
  internal func drawInRect(rect: CGRect) {
    
  }
  
  // MARK: - Managing Animations
  
  internal func startAnimating() {
    let currentTime = CACurrentMediaTime()
    
    if sublayers != nil {
      for layer in sublayers as [CALayer] {
        layer.speed     = 1
        layer.beginTime = layer.convertTime(currentTime, fromLayer: nil) - layer.timeOffset
      }
    }

    speed     = 1
    beginTime = convertTime(currentTime, fromLayer: nil) - timeOffset
  }
  
  internal func stopAnimating(hidesWhenStopped: Bool) {
    let currentTime = CACurrentMediaTime()
    
    if sublayers != nil {
      for layer in sublayers as [CALayer] {
        layer.timeOffset = layer.convertTime(currentTime, fromLayer: nil)
        layer.speed      = 0
      }
    }
    
    timeOffset = convertTime(currentTime, fromLayer: nil)
    speed      = 0
  }
}
