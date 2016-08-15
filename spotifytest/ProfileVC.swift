//
//  ProfileVC.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 6/28/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.title = ""
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "Profile"
        setInfo()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateImage(image: NSURL){
        let placeholderImage = UIImage(named: "profileplaceholder")
        imageView.af_setImageWithURL(image, placeholderImage: placeholderImage)
    }

    func setInfo(){
        
        let uri = appDelegate.mainUser.uri.absoluteString.characters.split{$0 == ":"}.map(String.init)
        print(uri)

        if appDelegate.mainUser.displayName != nil {
            lblName.text = appDelegate.mainUser.displayName
        }else{
            lblName.text = "\(uri[2])"
        }
        if appDelegate.mainUser.largestImage != nil {
            updateImage(appDelegate.mainUser.largestImage.imageURL)
        }else{
            let placeholderImage = UIImage(named: "profileplaceholder")
            imageView.image = placeholderImage
        }
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true

    }
    
    func logoutAnimation(){

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        appDelegate.window!.rootViewController = loginVC

        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            }, completion: nil)
        
        
    }
    @IBAction func logoutPressed(sender: AnyObject) {
        let delay = 0.4 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                SPTAuth.defaultInstance().session = nil
                self.appDelegate.mainUser = nil
                self.logoutAnimation()
            }
        }
        
    }


}
