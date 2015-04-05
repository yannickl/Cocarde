//
//  DetailViewController.swift
//  Cocarde
//
//  Created by Yannick Loriot on 13/03/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var cocardeView: CocardeView!
  @IBOutlet weak var toggleStartButton: UIButton!
  
  var cocardeStyle: CocardeStyle? {
    didSet {
      if isViewLoaded() {
        self.configureView()
      }
    }
  }
  
  func configureView() {
    // Update the user interface for the detail item.
    if let style = self.cocardeStyle {
      title                        = style.description
      cocardeView.style            = style
      cocardeView.animating        = true
      cocardeView.hidesWhenStopped = true
      
      switch style {
      case .Default:
        cocardeView.colors       = [UIColor(hex: 0x3498db), UIColor(hex: 0xecf0f1), UIColor(hex: 0xe74c3c)]
        cocardeView.loopDuration = 5
        cocardeView.segmentCount = 3
      case .Pie:
        cocardeView.colors       = [UIColor(hex: 0xdb5c65), UIColor(hex: 0xA7405d), UIColor(hex: 0x3b1c57), UIColor(hex: 0xf59155), UIColor(hex: 0x733633)]
        cocardeView.loopDuration = 12
        cocardeView.segmentCount = 18
      case .Equalizer:
        cocardeView.colors       = [UIColor(hex: 0x2ecc71), UIColor(hex: 0x3498db), UIColor(hex: 0x9b59b6), UIColor(hex: 0xe67e22), UIColor(hex: 0xc0392b), UIColor(hex: 0xe74c3c), UIColor(hex: 0xe74c8c)]
        cocardeView.loopDuration = 4
        cocardeView.segmentCount = 18
      case .ActivityIndicator:
        cocardeView.colors       = [UIColor(hex: 0x3bb3d4), UIColor(hex: 0xf29830), UIColor(hex: 0x44c8b8), UIColor(hex: 0xf86530), UIColor(hex: 0x4d4165)]
        cocardeView.loopDuration = 3
        cocardeView.segmentCount = 16
      case .Wave:
        cocardeView.colors       = [UIColor(hex: 0x2ecc71), UIColor(hex: 0x3498db), UIColor(hex: 0x9b59b6), UIColor(hex: 0xe67e22), UIColor(hex: 0xc0392b), UIColor(hex: 0xe74c3c), UIColor(hex: 0xe74c8c)]
        cocardeView.loopDuration = 4
        cocardeView.segmentCount = 14
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureView()
  }
  
  // MARK: - Actions
  
  @IBAction func toggleStartAction(sender: AnyObject) {
    cocardeView.animating = !cocardeView.animating
    
    toggleStartButton.setTitle(cocardeView.animating ? "Stop" : "Start", forState: .Normal)
  }
}

