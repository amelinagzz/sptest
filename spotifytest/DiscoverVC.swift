//
//  DiscoverVC.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 6/28/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var genresArray = [String]()
    var filteredArray = [String]()
    var searchMode = false

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.title = "Discover"
        self.tabBarItem.title = nil

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.title = ""

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        
        let barBackgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        barBackgroundView.backgroundColor = self.tableView.backgroundColor
        UIApplication.sharedApplication().delegate!.window!!.insertSubview(barBackgroundView, atIndex: 0)
        
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        
        textFieldInsideSearchBar?.font = UIFont(name: "Muli", size: 16)
        textFieldInsideSearchBar?.textColor = UIColor(red: 41/255.0, green: 34.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 10/255.0, green: 191/255.0, blue: 188/255.0, alpha: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
              
        let headers = [
            "Authorization": "Bearer \(SPTAuth.defaultInstance().session.accessToken)",
            "Accept": "application/json"
        ]


        Alamofire.request(.GET, "https://api.spotify.com/v1/recommendations/available-genre-seeds", parameters: nil, headers: headers)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    
                    if let array = JSON.valueForKey("genres") as? NSArray{
                        for genre in array{
                            self.genresArray.append(genre as! String)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMode{
            return filteredArray.count
        }else{
            return genresArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let row = indexPath.row
        if searchMode{
            cell.textLabel?.text = filteredArray[row]

        }else{
            cell.textLabel?.text = genresArray[row]
        }
        cell.textLabel?.font = UIFont(name: "Muli-Light", size: 18)
        cell.textLabel?.textColor = UIColor(red: 41/255.0, green: 34.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell

        let storyBoard : UIStoryboard = UIStoryboard(name: "Discover", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("PlayerVC") as! PlayerVC
        nextViewController.seed = currentCell.textLabel?.text
        self.navigationController?.pushViewController(nextViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath!, animated: true)

    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            searchMode = false
        }else{
            searchMode = true
            let lowerCaseStr = searchBar.text!.lowercaseString
            filteredArray = genresArray.filter({$0.rangeOfString(lowerCaseStr) != nil})
            
        }
        tableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchMode = false
        tableView.reloadData()


    }
}
