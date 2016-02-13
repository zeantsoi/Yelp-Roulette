//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zean Tsoi on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    var categories: [[String: String]]!
    var switchStates = [Int:Bool]()
    var delegate: FiltersViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if (isSelected) {
                selectedCategories.append(categories[row]["code"]!)
            }
            
        }
        if (selectedCategories.count > 0) {
            filters["categories"] = selectedCategories
        }
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = yelpCategories
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self

        cell.onSwitch.on = switchStates[indexPath.row] ?? false
//        if let on = switchStates[indexPath.row] {
//            cell.onSwitch.on = on
//        } else {
//            cell.onSwitch.on = true
//        }
        
//        if (switchStates[indexPath.row] != nil) {
//            cell.onSwitch.on = switchStates[indexPath.row]!
//        } else {
//            cell.onSwitch.on = true
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)
        switchStates[indexPath!.row] = value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
