//
//  ViewController.swift
//  HitList
//
//  Created by Gavin on 16/4/5.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    
    var people = [NSManagedObject]()
    
    //把数据存到entity中
    func saveName(name:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do{
            try managedContext.save()
            people.append(person)
        }
        catch let error as NSError {
            print("无法保存:\(error),\(error.userInfo)")
        }
        
    }
    
    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "新建名字", message: "添加一个新名字吧", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default , handler: { (action: UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.saveName(textField!.text!)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "列表"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //Mark :UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let person = people[indexPath.row]
        cell!.textLabel!.text = person.valueForKey("name") as? String
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //取出数据
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        }
        catch let error as NSError {
            print("无法取出数据:\(error),\(error.userInfo)")
        }
        
        
    }
   //删除数据
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle{
        case .Delete:
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let manageContext:NSManagedObjectContext = appDelegate.managedObjectContext
            manageContext.deleteObject(people[indexPath.row] as NSManagedObject)
            people.removeAtIndex(indexPath.row)
            do{
                try    manageContext.save()
            }catch let error as NSError{
                
                print("无法删除数据:\(error),\(error.userInfo)")
            }
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default :
            return
            
        }
    }


}

