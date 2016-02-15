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
    var sorts: [[String: String]]!
    var distances: [[String: String]]!
    
    var sectionCollapseStatus: [Bool]!
    
    var categorySwitchStates = [Int:Bool]()
    var selectedSortIndex: Int!
    var selectedDistanceIndex: Int!
    var dealsSelected = false
    
    var delegate:FiltersViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in categorySwitchStates {
            if (isSelected) {
                selectedCategories.append(categories[row]["code"]!)
            }
            
        }
        if (selectedCategories.count > 0) {
            filters["categories"] = selectedCategories
        }
        filters["sort"] = String(yelpSorts[selectedSortIndex]["code"]!)
        filters["distance"] = String(yelpDistances[selectedDistanceIndex]["code"]!)
        filters["deals"] = dealsSelected
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = yelpCategories
        sorts = yelpSorts
        distances = yelpDistances
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionCollapseStatus = []
        for _ in 0...3 {
            sectionCollapseStatus.append(true)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.delegate = self

//        var row = [String: String]()
        switch (indexPath.section) {
            case 0:
                cell.switchLabel.text = categories[indexPath.row]["name"]
                cell.onSwitch.on = categorySwitchStates[indexPath.row] ?? false
                break
            case 1:
                cell.switchLabel.text = sorts[indexPath.row]["name"]
                if (selectedSortIndex == nil) {
                    selectedSortIndex = 0
                }
                cell.onSwitch.on = indexPath.row == selectedSortIndex ? true : false
                break
            case 2:
                cell.switchLabel.text = distances[indexPath.row]["name"]
                if (selectedDistanceIndex == nil) {
                    selectedDistanceIndex = 0
                }
                cell.onSwitch.on = indexPath.row == selectedDistanceIndex ? true : false
                break
            case 3:
                cell.switchLabel.text = "Deals only"
                cell.onSwitch.on = dealsSelected
                break
            default:
                break
        }
//        cell.switchLabel.text = row["name"]

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
        switch(section) {
            case 0:
                return categories.count
            case 1:
                return sorts.count
            case 2:
                return distances.count
            default:
                return 1
            
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Categories"
        case 1:
            return "Sort"
        case 2:
            return "Distance"
        case 3:
            return "Deals"
        default:
            return ""
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        if (indexPath.section == 0) {
            categorySwitchStates[indexPath.row] = value
        } else if (indexPath.section == 1) {
            if (selectedSortIndex != indexPath.row) {
                if (value) {
                    selectedSortIndex = indexPath.row
                } else {
                    switchCell.setSelected(true, animated: false)
                }
            }
        } else if (indexPath.section == 2) {
            if (selectedDistanceIndex != indexPath.row) {
                if (value) {
                    selectedDistanceIndex = indexPath.row
                } else {
                    switchCell.setSelected(true, animated: false)
                }
            }
        } else if (indexPath.section == 3) {
            dealsSelected = value
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionCollapsed = sectionCollapseStatus[indexPath.section]
        if sectionCollapsed {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let singleTap = UITapGestureRecognizer(target: self, action: "toggleSection:")
        view.tag = section
        view.addGestureRecognizer(singleTap)
    }
    
    func toggleSection(sender: UITapGestureRecognizer) {
        if (sectionCollapseStatus[sender.view!.tag]) {
            sectionCollapseStatus[sender.view!.tag] = false
        } else {
            sectionCollapseStatus[sender.view!.tag] = true
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
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
