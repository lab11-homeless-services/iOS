//
//  GoogleMapsController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/10/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class GoogleMapsController {
    
    var googleDistanceResponse: [Row]!
    var serviceAddresses: [String]!
    var serviceDistance: String!
    var serviceTravelDuration: String!
    var key = "AIzaSyD2VA4VZXz5Hj7mr7s4L8Oybt1rX2fp7f4"
    
    var originLatitude: Double = 0
    var originLongitude: Double = 0
    var destinationLatitude: Double = 0
    var destinationLongitude: Double = 0
    
    typealias CompletionHandler = (Error?) -> Void
    static var baseURL: URL! { return URL( string: "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial" ) }
    
    func fetchServiceDistance(_ originLatitude: Double,
                              _ originLongitude: Double,
                              _ destinationLatitude: Double,
                              _ destinationLongitude: Double,
                              completion: @escaping CompletionHandler = { _ in }) {
        
        let originString = String(originLatitude) + "," + String(originLongitude)
        let destinationString = String(destinationLatitude) + "," + String(destinationLongitude)
        guard var components = URLComponents(url: GoogleMapsController.baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
            let queryItemImperial = URLQueryItem(name: "units", value: "imperial")
            let queryItemOrigin = URLQueryItem(name: "origins", value: originString)
            let queryItemDestination = URLQueryItem(name: "destinations", value: destinationString)
            let queryItemKey = URLQueryItem(name: "key", value: "\(key)")
        
        components.queryItems = [queryItemImperial, queryItemOrigin, queryItemDestination, queryItemKey]
        let requestURL = components.url
        
        URLSession.shared.dataTask(with: requestURL!) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse = try jsonDecoder.decode(GoogleDistance.self, from: data)
                let googleDistanceResponse = decodedResponse.rows
                self.serviceDistance = googleDistanceResponse[0].elements[0].distance.text
                self.serviceTravelDuration = googleDistanceResponse[0].elements[0].duration.text
                
                self.serviceAddresses = decodedResponse.destinationAddresses
                
                completion(nil)
            } catch {
                completion(error)
            }
            }.resume()
    }
    

    func fetchNearestShelter(_ originLatitude: Double,
                             _ originLongitude: Double,
                             completion: @escaping CompletionHandler = { _ in }) {
        
        let originString = String(originLatitude) + "," + String(originLongitude)
        let destinationString = "120+East+32nd+Street+New+York+NY+10016|800+Barretto+St+The+Bronx+NY+10474|257+West+30th+Street+New+York+NY+10001|2402+Atlantic+Avenue|25+Central+Avenue|703+Lexington+Avenue+Brooklyn+NY+11221|2402+Atlantic+Avenue|550+10th+Avenue+New+York+NY+10018"
        
        guard var components = URLComponents(url: GoogleMapsController.baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        let queryItemImperial = URLQueryItem(name: "units", value: "imperial")
        let queryItemOrigin = URLQueryItem(name: "origins", value: originString)
        let queryItemDestination = URLQueryItem(name: "destinations", value: destinationString)
        let queryItemKey = URLQueryItem(name: "key", value: "\(key)")
        
        components.queryItems = [queryItemImperial, queryItemOrigin, queryItemDestination, queryItemKey]
        guard let requestURL = components.url else { return }
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse = try jsonDecoder.decode(GoogleDistance.self, from: data)
                
                self.googleDistanceResponse = decodedResponse.rows
                self.serviceDistance = self.googleDistanceResponse[0].elements[0].distance.text
                self.serviceTravelDuration = self.googleDistanceResponse[0].elements[0].duration.text
                self.serviceAddresses = decodedResponse.destinationAddresses
                
                completion(nil)
            } catch {
                completion(error)
            }
            }.resume()
    }
    
    let googleURL =
"""
    
    https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.745377%2C-73.981306%7C40.81653%2C-73.889742%7C40.749139%2C-73.994016%7C40.676015%2C-73.905105%7C40.641112%2C-73.076825%7C40.689964%2C-73.932736%7C40.675854%2C-73.905247%7C40.675854%2C-73.905247%7C40.751979%2C-73.994054&key=AIzaSyD2VA4VZXz5Hj7mr7s4L8Oybt1rX2fp7f4

        
    https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=120+East+32nd+Street+New+York+NY+10016|800+Barretto+St+The+Bronx+NY+10474|257+West+30th+Street+New+York+NY+10001|2402+Atlantic+Avenue|25+Central+Avenue|703+Lexington+Avenue+Brooklyn+NY+11221|2402+Atlantic+Avenue|550+10th+Avenue+New+York+NY+10018&key=AIzaSyD2VA4VZXz5Hj7mr7s4L8Oybt1rX2fp7f4
    40.745377,-73.981306|40.81653,-73.889742|40.749139,-73.994016|40.676015,-73.905105|40.641112,-73.076825|40.689964,-73.932736|40.675854,-73.905247|40.675854,-73.905247|40.751979,-73.994054

    40.745377,-73.981306%7C40.81653%2C-73.889742%7C40.749139%2C-73.994016%7C40.676015%2C-73.905105%7C40.641112%2C-73.076825%7C40.689964%2C-73.932736%7C40.675854%2C-73.905247%7C40.675854%2C-73.905247%7C40.751979%2C-73.994054
    
    120+East+32nd+Street+New+York+NY+10016|800+Barretto+St+The+Bronx+NY+10474|257+West+30th+Street+New+York+NY+10001|2402+Atlantic+Avenue|25+Central+Avenue|703+Lexington+Avenue+Brooklyn+NY+11221|2402+Atlantic+Avenue|550+10th+Avenue+New+York+NY+10018
    
    %7C is a |
    %2C is a ,
    
"""
    // loop through the array of strings
    // convert each string to a double
    // increment by 2 starting at index 0 adding a | (pipe)
    // increment by 2 starting at index 1 adding a , (comma)
    // note sure if we will need to return a string
}
