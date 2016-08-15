//
//  Track+CoreDataProperties.swift
//  spotifytest
//
//  Created by Adriana Gonzalez on 7/8/16.
//  Copyright © 2016 AMGM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var albumImageUrl: String?
    @NSManaged var artistsToDisplay: String?
    @NSManaged var idnum: String?
    @NSManaged var previewUrl: String?
    @NSManaged var title: String?
    @NSManaged var uri: String?
    @NSManaged var ownerUri: String?
    @NSManaged var artists: NSSet?

}
