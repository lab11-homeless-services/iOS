//
//  OutreachServices.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct OutreachServices: Decodable {
 
    var afterSchool: [IndividualResource]
    var domesticViolence: [IndividualResource]
    var socialServices: [IndividualResource]
    var all: [IndividualResource]
    
    var outreachDictionary: [String: [IndividualResource]] {
        return ["afterSchool": afterSchool,
                "domesticViolence": domesticViolence,
                "socialServices": socialServices,
                "all": all]
    }
    var dictionary: NSDictionary {
        return outreachDictionary as NSDictionary
    }
}
