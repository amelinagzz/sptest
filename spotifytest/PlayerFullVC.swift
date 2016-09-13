//
//  PlayerFullVC.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/5/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import pop
import AlamofireImage
import CZPicker
import GTToast

class PlayerFullVC: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource {
    

    var card: Card!
    var track: Track!
    let placeholderImage = UIImage(named: "placeholder")!
    var uri: String!
    var playlists = [SPTPartialPlaylist]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtists: UILabel!
    
     override func viewWillDisappear(animated: Bool) {
        self.appDelegate.player.setIsPlaying(false) { (error) in
            if (error != nil) {
                print("*** Enabling playback got error: \(error)")
                return
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let font = UIFont(name: "Muli", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()
        }
        
        lblSongName.text = track.title
        lblArtists.text = track.artistsToDisplay
        uri = track.uri
        
        card = createCardFromNib()
        card.center = AnimationEngine.screenCenterPosition
        self.view.addSubview(card)
        updateArt(track.albumImageUrl!)

        playUsingSession(SPTAuth.defaultInstance().session)
        getUserPlaylistsUsingSession(SPTAuth.defaultInstance().session)
    }
    
    func createCardFromNib() -> Card?{
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
    }
    
    func configToast(playlist:String){
       let config = GTToastConfig(
            contentInsets: UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10),
            cornerRadius: 8.0,
            font: UIFont(name: "Muli", size: 18)!,
            textColor: UIColor.whiteColor(),
            textAlignment: NSTextAlignment.Center,
            backgroundColor: UIColor(red: 41/255.0, green: 34.0/255.0, blue: 31.0/255.0, alpha: 0.8),
            animation: GTToastAnimation.Alpha,
            displayInterval: 1.5,
            bottomMargin: 20.0
        )
        
        GTToast.create("Song added to \(playlist)", config: config, image: nil).show()

    }

    
    func playUsingSession(session:SPTSession) {
        // Create a new player if needed
        if (appDelegate.player == nil) {
            appDelegate.player = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID)
            appDelegate.player.loginWithSession(session, callback: { (error) -> Void in
                if (error != nil) {
                    print("*** Enabling playback got error: \(error)")
                    return
                }
            })

        }
        
        let trackURI = NSURL(string: "\(self.uri)")
        self.appDelegate.player.playURIs([trackURI!], withOptions: SPTPlayOptions(), callback: { (error: NSError!) in
            if error != nil {
                print(error.localizedDescription)
                return
            }else{
                self.appDelegate.player.setIsPlaying(true) { (error) in
                    if (error != nil) {
                        print("*** Enabling playback got error: \(error)")
                        return
                    }
                    
                }

            }
        })

        
    }
    
    func getUserPlaylistsUsingSession(session:SPTSession){
        
        SPTPlaylistList.playlistsForUserWithSession(session) { (error, playlistList) -> Void in
            if let playlistList = playlistList as? SPTPlaylistList{
                for playlist in playlistList.items{
                    var p = SPTPartialPlaylist()
                    p = playlist as! SPTPartialPlaylist
                    self.playlists.append(p)
                }
        
            }
        }
    }
    
    func updateArt(image: String){
        let url = NSURL(string: image)!
        card.shapeImage.af_setImageWithURL(url, placeholderImage: placeholderImage)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            card.alpha = 0
        } else {
            card.alpha = 1
        }
    }


    @IBAction func addToPlaylistPressed(sender: AnyObject) {
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                let picker = CZPickerView(headerTitle: "Select a playlist", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
                picker.delegate = self
                picker.dataSource = self
                picker.needFooterView = false
                picker.headerBackgroundColor =  UIColor(red: 10/255.0, green: 191/255.0, blue: 188/255.0, alpha: 1.0)
                picker.show()
            }
        }

    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return playlists.count
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return playlists[row].name
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print(playlists[row])
        addToPlaylist(SPTAuth.defaultInstance().session, playlist: playlists[row])
    }
    
    func addToPlaylist(session:SPTSession, playlist:SPTPartialPlaylist){
        SPTTrack.trackWithURI(NSURL(string:self.track.uri!), session: session, callback: { (error, result) -> Void in
            if error != nil {
                print(error)
            }
            if let track = result as? SPTTrack {
                SPTPlaylistSnapshot.playlistWithURI(playlist.uri, accessToken: session.accessToken) { (error, playlistSnapshot) -> Void in
                    
                    if let playlistSnapshot = playlistSnapshot as? SPTPlaylistSnapshot {
                        playlistSnapshot.addTracksToPlaylist([track], withSession: session, callback: {(error) -> Void in
                            if error != nil{
                                
                            }else{
                                self.configToast(playlist.name)
                            }
                        })
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        })
    }
}


