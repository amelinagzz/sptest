//
//  Artist+CoreDataProperties.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/1/16.
//  Copyright © 2016 AMGM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artist {

    @NSManaged var idnum: String?
    @NSManaged var name: String?
    @NSManaged var uri: String?
    @NSManaged var tracks: NSSet?

}
