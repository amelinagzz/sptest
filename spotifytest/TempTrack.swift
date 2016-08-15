//
//  TempTrack.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/1/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit

class TempTrack: NSObject {
    
    private var _idnum : String!
    private var _title : String!
    private var _previewUrl : String!
    private var _uri : String!
    private var _artists : [TempArtist]!
    private var _albumImageUrl : String!
    private var _artistsToDisplay: String!
    private var _ownerUri: String!

    var idnum : String{
        get{
            return _idnum
        }
    }
    
    var title : String{
        get{
            return _title
        }
    }
    
    var previewUrl : String{
        get{
            return _previewUrl
        }
    }
    
    var uri : String{
        get{
            return _uri
        }
    }
    
    var artists : [TempArtist]{
        get{
            return _artists
        }
    }
    
    var albumImageUrl : String{
        get{
            return _albumImageUrl
        }
    }
    
    var artistsToDisplay : String{
        get{
            return _artistsToDisplay
        }
    }
    
    var ownerUri : String{
        get{
            return _ownerUri
        }
    }
    
    init(idnum: String, title: String, previewUrl: String, uri: String, artists: [TempArtist], albumImageUrl: String, ownerUri: String) {
        
        self._idnum = idnum
        self._title = title
        self._previewUrl = previewUrl
        self._uri = uri
        self._artists = artists
        self._albumImageUrl = albumImageUrl
        self._ownerUri = ownerUri
        
        var tempString = ""
        
        for artist in artists{
            tempString += "\(artist.name), "
        }
        
        tempString = tempString.substringToIndex(tempString.endIndex.predecessor())
        tempString = tempString.substringToIndex(tempString.endIndex.predecessor())
        
        self._artistsToDisplay = tempString
        
    }

}
