//
//  FavsVC.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 6/28/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import CoreData
import SWTableViewCell

class FavsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController : NSFetchedResultsController!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        tableView.delegate = self
        tableView.dataSource = self
        print(appDelegate.mainUser.uri.absoluteString)
        //attemptFetch()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.title = ""
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "Favorites"
        fetchedResultsController = nil

        attemptFetch()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        cell.selectionStyle = .None
        configureCell(cell, indexPath: indexPath)
        cell.rightUtilityButtons = rightButtons() as [AnyObject]
        
        cell.delegate = self

        return cell
        
    }
    
    func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as? Track
        let storyBoard : UIStoryboard = UIStoryboard(name: "Favs", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("PlayerFullVC") as! PlayerFullVC
        nextViewController.track = record
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    
    func configureCell(cell: TrackCell, indexPath: NSIndexPath){
        if let record = fetchedResultsController.objectAtIndexPath(indexPath) as? Track{
            cell.configureCell(record)
            cell.albumImage.image = UIImage(named: "placeholder")
            let xurl = record.albumImageUrl
            cell.configureCellWithURLString(xurl!, placeholderImage: cell.albumImage.image!)
        }
    }
    
    func rightButtons() -> NSArray{
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: 252/255.0, green: 53/255.0, blue: 76/255.0, alpha: 1.0), icon: UIImage(named: "delete-icon"))
        return rightUtilityButtons
    }

    func attemptFetch(){
        
        setFetchedResults()
        
        do{
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        }catch{
            let error = error as NSError
            print(error.description)
        }
    }
    
    func setFetchedResults(){

        let fetchRequest = NSFetchRequest(entityName: "Track")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "%K == %@", "ownerUri", "\(appDelegate.mainUser.uri.absoluteString)")
        fetchRequest.predicate = predicate
        
        print(appDelegate.mainUser.uri.absoluteString)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        fetchedResultsController = controller
        
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath{
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath = indexPath{
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRowAtIndexPath(indexPath)
            }
            break
        case .Move:
            if let indexPath = indexPath{
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
        default:
            break
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {

        let indexPath = self.tableView.indexPathForCell(cell)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext
        let record = fetchedResultsController.objectAtIndexPath(indexPath!) as? Track
        context.deleteObject(record!)
        do {
            try context.save()
        } catch _ {
        }

    }
    

}
