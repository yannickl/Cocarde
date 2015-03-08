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
  Cocarde style
*/
public enum CocardeStyle: Int {
  /// Default style
  case Default   = 0
  /// Pie style
  case Pie       = 1
  // Equalizer style
  case Equalizer = 2
}

/**
  Cocarde view
*/
@IBDesignable public final class CocardeView: UIView {
  @IBInspectable public var segmentCount: UInt = 15 {
    didSet {
      updateCocadeLayer()
    }
  }
  
  @IBInspectable public var loopDuration: Double = 12 {
    didSet {
      updateCocadeLayer()
    }
  }
  
  @IBInspectable public var colorsAsString: String = "" {
    didSet {
      updateCocadeLayer()
    }
  }
  
  @IBInspectable public var animating: Bool = false {
    didSet {
      containerLayer?.animating = animating
    }
  }
  
  @IBInspectable public var hidesWhenStopped: Bool = false {
    didSet {
      containerLayer?.hidesWhenStopped = hidesWhenStopped
    }
  }
  
  @IBInspectable public var style: CocardeStyle = .Default {
    didSet {
      updateCocadeLayer()
    }
  }
  
  private var containerLayer: CocardeLayer?
  
  public var colors = [UIColor(hexString: "#DB5C65"), UIColor(hexString: "#A7405D"), UIColor(hexString: "#3B1C57"), UIColor(hexString: "#F59155"), UIColor(hexString: "#733633")]
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerLayer?.frame = bounds
  }
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if containerLayer == nil {
      containerLayer                   = layerWithStyle(style)
      containerLayer?.hidesWhenStopped = hidesWhenStopped
      containerLayer?.animating        = animating
      layer.addSublayer(containerLayer)
    }
  }
  public override func awakeFromNib() {
    super.awakeFromNib()
    
    updateCocadeLayer()
  }
  
  // MARK: - Updating the Layer
  
  private func updateCocadeLayer() {
    if containerLayer != nil {
      containerLayer?.removeFromSuperlayer()
    }
    
    containerLayer                   = layerWithStyle(style)
    containerLayer?.hidesWhenStopped = hidesWhenStopped
    containerLayer?.animating        = animating
    layer.addSublayer(containerLayer)
  }
  
  private func layerWithStyle(style: CocardeStyle) -> CocardeLayer {
    switch(style) {
    case .Pie:
      return PieLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    case .Equalizer:
      return EqualizerLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    default:
      return DefaultLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    }
  }
  
  var styleNumber: Int = 0
  public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    styleNumber = (styleNumber + 1) % 3
    
    if styleNumber == 0 {
      loopDuration = 20
    }
    else {
      loopDuration = 12
    }
    
    style = CocardeStyle(rawValue: styleNumber)!
  }
}