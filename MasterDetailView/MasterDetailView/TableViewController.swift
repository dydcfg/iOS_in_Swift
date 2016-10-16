//
//  TableViewController.swift
//  MasterDetailView
//
//  Created by Daniel Hauagge on 9/29/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // var functions : [String] = ["x", "x**2", "x**3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForName("functionDBChanged", object: FunctionsDB.sharedInstance, queue: nil) { (NSNotification) in
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat{
            
            return 60.0
    }
    
    
    func addNewFunctionPressed(){
        FunctionsDB.sharedInstance.functions.append("")
        FunctionsDB.sharedInstance.thumbnail.append(UIImage())
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int)-> UIView?{
        let superFrame = tableView.frame
        let view = UIView(frame: CGRectMake(0, 0, superFrame.width, superFrame.height))
        let button = UIButton(type: .ContactAdd) as UIButton
        button.frame = CGRectMake(superFrame.width - 100, 0, 100, 100)
        button.addTarget(self, action: #selector(addNewFunctionPressed), forControlEvents: .TouchUpInside)
        
        let textLabel = UILabel(frame: CGRectMake(5, 0, 100, 100))
        textLabel.text = "Functions"
        
        view.addSubview(button)
        view.addSubview(textLabel)
        
        return view
        
    }
    
    
    
    override func tableView(tableView:UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            FunctionsDB.sharedInstance.functions.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FunctionsDB.sharedInstance.functions.count
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
//        let cell = tableView.dequeueReusableCellWithIdentifier("function_cell_id",
//                                                               forIndexPath: indexPath)
//        
////        indexPath.section
////        indexPath.row
//        
//        cell.detailTextLabel?.text = FunctionsDB.sharedInstance.functions[indexPath.row]
//        cell.textLabel?.text = "f(x) ="

        let cell = tableView.dequeueReusableCellWithIdentifier("function_custom_cell_id",
                                                               forIndexPath: indexPath) as! TableViewCell
        
        //        indexPath.section
        //        indexPath.row
        
        cell.functionLabel.text = FunctionsDB.sharedInstance.functions[indexPath.row]
        cell.thumbnail.image = FunctionsDB.sharedInstance.thumbnail[indexPath.row]
        cell.thumbnail.contentMode = UIViewContentMode.ScaleToFill
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //segue.identifier // <- can be set in the storyboard. Use this if you have multple sugues that need different logic.
        
        let cell = sender as! TableViewCell
        let nextViewController = segue.destinationViewController as! FunctionPlottingViewController
        
        let f = cell.functionLabel.text!  // detailTextLabel?.text!
        let fIdx = tableView.indexPathForCell(cell)!.row
        
        // nextViewController.expressionEntryTextField.text = f // This wont work because outlets are not yet connected in this method
        nextViewController.expressionFromSegue = f
        nextViewController.expressionIdxFromSegue = fIdx
    }
}
