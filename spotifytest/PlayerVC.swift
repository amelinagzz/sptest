//
//  PlayerVC.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 6/29/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit
import pop
import Alamofire
import AVFoundation
import AlamofireImage
import CoreData

class PlayerVC: UIViewController {

    var currentCard: Card!
    var prevCard: Card!
    var seed: String!
    var tracks = [TempTrack]()
    var session: SPTSession!
    var player: SPTAudioStreamingController!
    var audioPlayer: AVPlayer!
    var newSet: Bool!
    let placeholderImage = UIImage(named: "placeholder")!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer : NSTimer!

    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtists: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "Muli", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()
        }
        
        self.title = seed.capitalizedString
        currentCard = createCardFromNib()
        currentCard.center = AnimationEngine.screenCenterPosition
        self.view.addSubview(currentCard)
        getSongs()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        
        let heartImg = UIImage(named: "favs-red-icon")
        let templateHeart = heartImg!.imageWithRenderingMode(.AlwaysTemplate)
        favBtn.setImage(templateHeart, forState: .Normal)
        favBtn.tintColor = UIColor(red: 252/255.0, green: 52/255.0, blue: 76/255.0, alpha: 1.0)
        
        let nextImg = UIImage(named: "next-icon")
        let templateNext = nextImg!.imageWithRenderingMode(.AlwaysTemplate)
        nextBtn.setImage(templateNext, forState: .Normal)
        nextBtn.tintColor = UIColor(red: 10/255.0, green: 191/255.0, blue: 188/255.0, alpha: 1.0)
        
        favBtn.enabled = false
        nextBtn.enabled = false

        
    } 
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            currentCard.alpha = 0
        } else {
            currentCard.alpha = 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        newSet = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        currentCard.alpha = 0
        //timer.invalidate()

    }
    
    
    func getSongs(){
        
        let headers = [
            "Authorization": "Bearer \(SPTAuth.defaultInstance().session.accessToken)",
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(.GET, "https://api.spotify.com/v1/recommendations", parameters: ["seed_genres":"\(seed)"], headers: headers)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    
                    if let array = JSON.valueForKey("tracks") as? NSArray{
                        for track in array{
                            let idnum = track.valueForKey("id") as? String
                            let title = track.valueForKey("name") as? String
                            let previewUrl = track.valueForKey("preview_url") as? String
                            let uri = track.valueForKey("uri") as? String
                            var albumImg = ""
                            
                            var artistsArray = [TempArtist]()
                            if let artists = track.valueForKey("artists") as? NSArray{
                            
                                for artist in artists{
                                    
                                    let name = artist.valueForKey("name") as? String
                                    let idnum = artist.valueForKey("id") as? String
                                    let uri = artist.valueForKey("uri") as? String
                                    
                                    let a = TempArtist(idnum: idnum!, name: name!, uri: uri!)
                                    artistsArray.append(a)
                                }
                            
                            }
                            
                            if let album = track.valueForKey("album") as? NSDictionary{
                                if let images = album.valueForKey("images") as? NSArray{
                                    let imageUrl = images[1].valueForKey("url")as? String
                                    albumImg = imageUrl!
                                }
                            }
                            
                            if(previewUrl != nil){
                                let t = TempTrack(idnum: idnum!, title: title!, previewUrl: previewUrl!, uri: uri!, artists: artistsArray, albumImageUrl: albumImg, ownerUri: self.appDelegate.mainUser.uri.absoluteString)
                                self.tracks.append(t)
                            }
                            
                            
                           
                            
                        }
                        
                        print(self.tracks.count)
                        if(self.newSet == true){
                            self.playTrack()
                            self.favBtn.enabled = true
                            self.nextBtn.enabled = true
                        }
                        self.newSet = false
                    }
                    
                }
        }
    }
    
    
    func playTrack(){
        let track = tracks[0]
        let sound = NSURL(string: track.previewUrl)
        print(track.previewUrl)
        
        
        self.audioPlayer = AVPlayer(URL: sound!)
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayerVC.checkSong),userInfo: nil, repeats: true)

        self.audioPlayer.rate = 1.0
        
        //self.audioPlayer.play()
        updateArt(track.albumImageUrl)
        lblSongName.text = track.title
        lblArtists.text = track.artistsToDisplay
        

    }
    
    func checkSong() {
        if self.audioPlayer.isPlaying == false {
            timer.invalidate()
            showNextCard(false)
        
        }
    }
  
    func updateArt(image: String){
        let url = NSURL(string: image)!
        currentCard.shapeImage.af_setImageWithURL(url, placeholderImage: placeholderImage)
    }
    
    func createCardFromNib() -> Card?{
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
    }
    
    func showNextCard(result:Bool){
        
        if let current = currentCard {
            let cardToRemove = current
            prevCard = current
            currentCard = nil
            AnimationEngine.animatetoPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition, completion: { (anim: POPAnimation!, Bool) -> Void in
                cardToRemove.removeFromSuperview()
            })
            
        }
        
        if let next = createCardFromNib() {
            next.center = AnimationEngine.offScreenRightPosition
            self.view.addSubview(next)
            currentCard = next
            
            AnimationEngine.animatetoPosition(next, position: AnimationEngine.screenCenterPosition, completion: { (anim: POPAnimation!, finished: Bool) -> Void in
            })
        }
        
        if tracks.count == 3 {
            getSongs()
        }
        tracks.removeAtIndex(0)
        playTrack()
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        
        let track = tracks[0]
        let trackToSave = NSEntityDescription.insertNewObjectForEntityForName("Track", inManagedObjectContext: appDelegate.managedObjectContext) as! Track
        trackToSave.title = track.title
        trackToSave.albumImageUrl = track.albumImageUrl
        trackToSave.idnum = track.idnum
        trackToSave.previewUrl = track.previewUrl
        trackToSave.uri = track.uri
        trackToSave.artistsToDisplay = track.artistsToDisplay
        trackToSave.ownerUri = appDelegate.mainUser.uri.absoluteString
        
        var artistsArray = [Artist]()
        
        for artist in track.artists {
            let artistToSave = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: appDelegate.managedObjectContext) as! Artist
            artistToSave.idnum = artist.idnum
            artistToSave.name = artist.name
            artistToSave.uri = artist.uri
            artistsArray.append(artistToSave)
            
        }
        trackToSave.artists = NSSet(array: artistsArray)
        
        appDelegate.saveContext()
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.favBtn.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
        }
        
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.showNextCard(true)
            }
        }

        

    }

    @IBAction func nextPressed(sender: AnyObject) {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18

        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.nextBtn.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
        }
        
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.showNextCard(false)
            }
        }

    }
    
    
}
extension AVPlayer {
    
    var isPlaying: Bool {
        return ((rate != 0) && (error == nil))
    }
}
