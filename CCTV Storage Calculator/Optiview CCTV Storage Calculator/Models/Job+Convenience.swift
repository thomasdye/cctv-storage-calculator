//
//  Job+Convenience.swift
//  CCTV Storage Calculator
//
//  Created by Thomas Dye on 4/28/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

enum SystemType: String, CaseIterable {
    case IP
    case COAX
    case Hybrid
}

extension Job {
    @discardableResult convenience init(jobName: String,
                                        customerName: String,
                                        customerPhoneNumber: String,
                                        systemType: SystemType = .COAX,
                                        numberOfCameras: Int64,
                                        totalStorage: String,
                                        jobNotes: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up the NSManagedObject portion of the Task object
        self.init(context: context)
            
        // Assign our unique values to the attributes we created in the data model file
        self.jobName = jobName
        self.customerName = customerName
        self.customerPhoneNumber = customerPhoneNumber
        self.systemType = systemType.rawValue
        self.numberOfCameras = numberOfCameras
        self.totalStorage = totalStorage
        self.jobNotes = jobNotes
            
        }
}
