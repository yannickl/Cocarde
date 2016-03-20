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
  The visual style of the cocarde view.

  - Default: A cocarde indicator style
  - Pie: A pie chart indicator style
  - Equalizer: A view meter indicator style
  - ActivityIndicator: An activity indicator style like
  - Wave: A wave propagation indicator style
*/
public enum CocardeStyle: Int, CustomStringConvertible {
  /// Default style
  case Default = 0
  /// Pie style
  case Pie = 1
  // Equalizer style
  case Equalizer = 2
  // Activity Indicator style
  case ActivityIndicator = 3
  // Wave style
  case Wave = 4
  
  /// A list including all values
  static let allValues = [Default, Pie, Equalizer, ActivityIndicator, Wave]
  
  /// A textual representation of the style
  public var description : String {
    get {
      switch(self) {
      case Default:
        return "Default"
      case Pie:
        return "Pie"
      case Equalizer:
        return "Equalizer"
      case ActivityIndicator:
        return "Activity Indicator"
      case Wave:
        return "Wave"
      }
    }
  }
}

/**
  Use a cocarde view to show that a task is in progress with custom
  representations in order to replace the UIActivityIndicatorView.

  Its main purpose is to provided colorful activity indicator.

  You control when a cocarde animates by calling the startAnimating and 
  stopAnimating methods. To automatically hide the cocarde when animation
  stops, set the hidesWhenStopped property to true.
*/
@IBDesignable public final class CocardeView: UIView {
  /// The number of segment used to display the cocarde.
  @IBInspectable public var segmentCount: UInt = 15 {
    didSet {
      updateCocadeLayer()
    }
  }
  
  /// The time of the loop between the start and the end of the animation.
  @IBInspectable public var loopDuration: Double = 12 {
    didSet {
      updateCocadeLayer()
    }
  }
  
  /// Manage the animation of the cocarde.
  @IBInspectable public var animating: Bool = false {
    didSet {
      containerLayer?.animating = animating
    }
  }
  
  /**
    A Boolean value that controls whether the receiver is hidden when the
    animation is stopped.
  */
  @IBInspectable public var hidesWhenStopped: Bool = false {
    didSet {
      containerLayer?.hidesWhenStopped = hidesWhenStopped
    }
  }
  
  /// The basic appearance of the cocarde view.
  @IBInspectable public var style: CocardeStyle = .Default {
    didSet {
      updateCocadeLayer()
    }
  }
  
  /// The layer displaying the cocarde view.
  private var containerLayer: CocardeLayer?
  
  /// The colors used by the cocarde view.
  public var colors = [UIColor(hex: 0x3498db), UIColor(hex: 0xecf0f1), UIColor(hex: 0xe74c3c)]
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerLayer?.frame = bounds
  }
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if containerLayer == nil {
      let cl              = layerWithStyle(style)
      cl.hidesWhenStopped = hidesWhenStopped
      cl.animating        = animating

      containerLayer = cl

      layer.addSublayer(cl)
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()

    updateCocadeLayer()
  }
  
  // MARK: - Managing a Cocarde View
  
  /**
    Starts the animation of the cocarde view.
  */
  func startAnimating() {
    animating = true
  }
  
  /**
    Stops the animation of the cocarde view.
  */
  func stopAnimating() {
    animating = true
  }
  
  // MARK: - Updating the Layer
  
  private func updateCocadeLayer() {
    if let cl = containerLayer {
      cl.removeFromSuperlayer()
    }

    let cl              = layerWithStyle(style)
    cl.hidesWhenStopped = hidesWhenStopped
    cl.animating        = animating

    containerLayer = cl
    
    layer.addSublayer(cl)
  }
  
  private func layerWithStyle(style: CocardeStyle) -> CocardeLayer {
    switch(style) {
    case .Pie:
      return PieLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    case .Equalizer:
      return EqualizerLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    case .ActivityIndicator:
      return ActivityIndicatorLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    case .Wave:
      return WaveLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    default:
      return DefaultLayer(segmentCount: segmentCount, segmentColors: colors, loopDuration: loopDuration)
    }
  }
}