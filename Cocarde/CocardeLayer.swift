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

/**
  Abstract class
*/
internal class CocardeLayer: CALayer {
  private let hideAnimationKey   = "plots.hide"
  private let revealAnimationKey = "plots.reveal"
  
  let segmentCount: UInt
  let segmentColors: [UIColor]
  let loopDuration: Double
  
  internal var hideAnimationDefaultKeyPath: String {
    get {
      return "transform.scale"
    }
  }
  
  var animating: Bool = false {
    didSet {
      if animating {
        startAnimating()
      }
      else {
        stopAnimating(true)
      }
    }
  }
  
  var hidesWhenStopped: Bool = false {
    didSet {
      stopAnimating(true)
    }
  }
  
  override var frame: CGRect {
    didSet {
      clearDrawing()
      
      drawInRect(bounds)
      
      if !animating {
        stopAnimating(false)
      }
    }
  }
  
  /**
    Initializes a layer with parameters
  
    :param: segmentCount  Generic parameters display
    :param: segmentColors Color list
    :param: loopDuration  Duration in second for the loop animation
  */
  required init(segmentCount segments: UInt, segmentColors colors: [UIColor], loopDuration duration: Double) {
    segmentCount  = segments
    segmentColors = colors
    loopDuration  = duration
    
    super.init()
  }
  
  override init!(layer: AnyObject!) {
    if layer is CocardeLayer {
      segmentCount     = layer.segmentCount
      segmentColors    = layer.segmentColors
      loopDuration     = layer.loopDuration
      hidesWhenStopped = layer.hidesWhenStopped
      animating        = layer.animating
    }
    else {
      fatalError("init(layer:) has not been implemented")
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
    if sublayers != nil {
      for layer in sublayers as [CALayer] {
        layer.speed = 1
      }
    }

    speed = 1
    
    if animationForKey(hideAnimationKey) != nil {
      let anim            = CABasicAnimation(keyPath: hideAnimationDefaultKeyPath)
      anim.duration       = 0.4
      anim.fromValue      = 0
      anim.toValue        = 1
      anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      
      addAnimation(anim, forKey: revealAnimationKey)
      removeAnimationForKey(hideAnimationKey)
    }
  }
  
  internal func stopAnimating(animated: Bool) {
    if !hidesWhenStopped {
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
    else {
      speed = 1
      
      let anim                 = CABasicAnimation(keyPath: hideAnimationDefaultKeyPath)
      anim.duration            = animated ? 0.4 : 0.01
      anim.toValue             = 0
      anim.removedOnCompletion = false
      anim.fillMode            = kCAFillModeBoth
      anim.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
 
      addAnimation(anim, forKey: hideAnimationKey)
    }
  }
}
