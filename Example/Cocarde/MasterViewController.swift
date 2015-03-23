//
//  MasterViewController.swift
//  Cocarde
//
//  Created by Yannick Loriot on 13/03/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
  var detailViewController: DetailViewController? = nil
  var cocardeStyles                               = CocardeStyle.allValues

  override func awakeFromNib() {
    super.awakeFromNib()
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Styles"
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let object = cocardeStyles[indexPath.row] as CocardeStyle
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.cocardeStyle = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  }

  // MARK: - Table View

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cocardeStyles.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

    let object           = cocardeStyles[indexPath.row] as CocardeStyle
    cell.textLabel!.text = object.description
    
    return cell
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
}

