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
      title                 = style.description
      cocardeView.style     = style
      cocardeView.animating = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureView()
  }
}

