//
//  ViewController.swift
//  Do It
//
//  Created by Harshil on 09/03/16.
//  Copyright © 2016 Harshil Parikh. All rights reserved.
//

import UIKit
import CoreData


class tableViewController: UITableViewController{
    
    var listitems = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self , action: Selector("addItem"))
    
    }
    func addItem() {
        let alertController = UIAlertController(title: "Type", message: "Type", preferredStyle: .Alert)
        let confirmaction = UIAlertAction(title: "Type", style: .Default, handler: {
            
            (_) in
            if let field =  alertController.textFields![0] as? UITextField {
                self.saveItem(field.text!)
                self.tableView.reloadData()
                
            }
            
        })
        
        let cancelaction = UIAlertAction (title: "Cancel", style: .Cancel, handler: nil)
        alertController.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "Type in something"
        })
        
        alertController.addAction(confirmaction)
        alertController.addAction(cancelaction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func saveItem(itemToSave : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ListEntity" , inManagedObjectContext: managedContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
       
        item.setValue(itemToSave, forKey:"item")
        
        do {
            try managedContext.save()
            listitems.append(item)
        }
        catch {
            print("something went wrong ")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listitems = results as! [NSManagedObject]
        }catch {
            print("Error pal")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
      
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        
        managedContext.deleteObject(listitems[indexPath.row])
        listitems.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listitems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let item = listitems[indexPath.row]
        cell.textLabel?.text = (item.valueForKey("item") as! String)
        return cell
    }
    
    

}

