//
//  LoginVC.swift
//  songq
//
//  Created by Adriana Gonzalez on 6/28/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import GTToast

class LoginVC: UIViewController {

    
    let spotifyClientID = "39d33090febb4bc2ae8d330b0b58edae"
    let spotifyRedirectURI = "spotifytest://spotify/callback"
    let kTokenSwapURL = "https://peaceful-sierra-1249.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "https://peaceful-sierra-1249.herokuapp.com/refresh"
    var kSessionUserDefaultsKey = "SpotifySession"

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.errorLogin(_:)), name:"SpotifyLoginError", object: nil)

        SPTAuth.defaultInstance().clientID        = spotifyClientID
        SPTAuth.defaultInstance().redirectURL     = NSURL(string: spotifyRedirectURI)
        //SPTAuth.defaultInstance().tokenRefreshURL     = NSURL(string: kTokenRefreshServiceURL)
        //SPTAuth.defaultInstance().tokenSwapURL    = NSURL(string: kTokenSwapURL)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthUserLibraryModifyScope]
        
        print(SPTAuth.defaultInstance().loginURL)
        
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        let delay = 0.4 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                UIApplication.sharedApplication().openURL(SPTAuth.defaultInstance().loginURL)
            }
        }

    }
    
    func configToast(){
        let config = GTToastConfig(
            contentInsets: UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10),
            cornerRadius: 8.0,
            font: UIFont(name: "Muli", size: 18)!,
            textColor: UIColor.whiteColor(),
            textAlignment: NSTextAlignment.Center,
            backgroundColor: UIColor(red: 41/255.0, green: 34.0/255.0, blue: 31.0/255.0, alpha: 0.8),
            animation: GTToastAnimation.Alpha,
            displayInterval: 2.0,
            bottomMargin: 20.0
        )
        
        GTToast.create("Error logging in to Spotify. Please try again.", config: config, image: nil).show()
        
    }
    
    func errorLogin(notification: NSNotification){
        configToast()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

