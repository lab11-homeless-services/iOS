//
//  ShelterDetails.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/11/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

//struct ShelterDetails: Codable {
//
//    var all: [ShelterDetailsIndividualResource]
//    var men: [ShelterDetailsIndividualResource]
//    var women: [ShelterDetailsIndividualResource]
//    var youth: [ShelterDetailsIndividualResource]
//
////    var shelterDictionary: [String: [ShelterDetailsIndividualResource]] {
////        return ["all": all,
////                "men": men,
////                "women": women,
////                "youth": youth]
////    }
////    var dictionary: NSDictionary {
////        return shelterDictionary as NSDictionary
////    }
//
//}

struct ShelterIndividualResource: Codable {
    
    enum SheltersCodingKeys: String, CodingKey {
        case address
        case city
        case details
        case hours
        case keywords
        case latitude
        case longitude
        case name
        case phone
        case postalCode = "postal code"
        case state
        case services
        
    }
    
    var address: String
    var city: String
    var details: [String]?
    var hours: String?
    
    var keywords: String
    var latitude: String
    var longitude: String
    
    var name: String
    var phone: String
    var postalCode: String
    var state: String
    
    var services: [String]?
    
    init(from decoder: Decoder) throws {
        
        // Container representing top level of information, which is a dictionary
        let container = try decoder.container(keyedBy: SheltersCodingKeys.self)
        
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        
        // contains an array, but is not nested
        details = try container.decodeIfPresent([String].self, forKey: .details)
        services = try container.decodeIfPresent([String].self, forKey: .services)
        
        hours = try container.decodeIfPresent(String.self, forKey: .hours)
        keywords = try container.decode(String.self, forKey: .keywords)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        state = try container.decode(String.self, forKey: .state)
                
    }
}

struct ShelterJSON: Codable {
    
    var JSON: [ShelterIndividualResource]
}

