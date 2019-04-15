//
//  Shelters.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Shelters: Decodable {

    var all: [IndividualResource]
    var men: [IndividualResource]
    var women: [IndividualResource]
    var youth: [IndividualResource]
    
    var shelterDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "men": men,
                "women": women,
                "youth": youth]
    }
    var dictionary: NSDictionary {
        return shelterDictionary as NSDictionary
    }

}

// This also works, but to streamline, we can have the subcategories be arrays of Individual Resource
//struct ShelterDetailsIndividualResource: Decodable {
//
//    enum SheltersCodingKeys: String, CodingKey {
//        case address
//        case city
//        case details
//        case hours
//        case keywords
//        case latitude
//        case longitude
//        case name
//        case phone
//        case postalCode = "postal code"
//        case state
//        case services
//
//    }
//
//    var address: String
//    var city: String
//    var details: [String]?
//    var hours: String?
//
//    var keywords: String
//    var latitude: String
//    var longitude: String
//
//    var name: String
//    var phone: String
//    var postalCode: String
//    var state: String
//
//    var services: [String]?
//
//    init(from decoder: Decoder) throws {
//
//        // Container representing top level of information, which is a dictionary
//        let container = try decoder.container(keyedBy: SheltersCodingKeys.self)
//
//        address = try container.decode(String.self, forKey: .address)
//        city = try container.decode(String.self, forKey: .city)
//
//        // contains an array, but is not nested
//        details = try container.decodeIfPresent([String].self, forKey: .details)
//
//        hours = try container.decodeIfPresent(String.self, forKey: .hours)
//        keywords = try container.decode(String.self, forKey: .keywords)
//        latitude = try container.decode(String.self, forKey: .latitude)
//        longitude = try container.decode(String.self, forKey: .longitude)
//        name = try container.decode(String.self, forKey: .name)
//        phone = try container.decode(String.self, forKey: .phone)
//        postalCode = try container.decode(String.self, forKey: .postalCode)
//        state = try container.decode(String.self, forKey: .state)
//
//        // contains an array, but is not nested
//        services = try container.decodeIfPresent([String].self, forKey: .services)
//    }
//}
//
//struct JSON: Decodable {
//
//    var JSON: [ShelterDetailsIndividualResource]
//}








//struct ShelterIndividualResource: Codable {
//    
//    enum SheltersCodingKeys: String, CodingKey {
//        case address
//        case city
//        case details
//        case hours
//        case keywords
//        case latitude
//        case longitude
//        case name
//        case phone
//        case postalCode = "postal code"
//        case state
//        case services
//        
//    }
//    
//    var address: String
//    var city: String
//    var details: [String]?
//    var hours: String?
//    
//    var keywords: String
//    var latitude: String
//    var longitude: String
//    
//    var name: String
//    var phone: String
//    var postalCode: String
//    var state: String
//    
//    var services: [String]?
//
//    init(from decoder: Decoder) throws {
//        
//        // Container representing top level of information, which is a dictionary
//        let container = try decoder.container(keyedBy: SheltersCodingKeys.self)
//        
//        address = try container.decode(String.self, forKey: .address)
//        city = try container.decode(String.self, forKey: .city)
//        
//        // contains an array, but is not nested
//        details = try container.decodeIfPresent([String].self, forKey: .details)
//        
//        hours = try container.decodeIfPresent(String.self, forKey: .hours)
//        keywords = try container.decode(String.self, forKey: .keywords)
//        latitude = try container.decode(String.self, forKey: .latitude)
//        longitude = try container.decode(String.self, forKey: .longitude)
//        name = try container.decode(String.self, forKey: .name)
//        phone = try container.decode(String.self, forKey: .phone)
//        postalCode = try container.decode(String.self, forKey: .postalCode)
//        state = try container.decode(String.self, forKey: .state)
//        
//        // contains an array, but is not nested
//        services = try container.decodeIfPresent([String].self, forKey: .services)
//    }
//}

