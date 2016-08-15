//
//  TempArtist.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/1/16.
//  Copyright © 2016 AMGM. All rights reserved.
//

import UIKit

class TempArtist: NSObject {
    
    private var _idnum : String!
    private var _name : String!
    private var _uri : String!

    
    var idnum : String{
        get{
            return _idnum
        }
    }
    
    var name : String{
        get{
            return _name
        }
    }
    
    var uri : String{
        get{
            return _uri
        }
    }

    init(idnum: String, name: String, uri: String){
        self._idnum = idnum
        self._name = name
        self._uri = uri
    }
}
