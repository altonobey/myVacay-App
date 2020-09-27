//
//  YelpClient.swift
//  myVacay
//
//  Created by Ahmed AlTonobey and Nolan Turley on 11/10/18.
//  Copyright © 2018 Ahmed AlTonobey. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

let yelpAPIKey = "YJl75It4Nql4fZa3GxQdNzoFzvXUt3GUgom9XwlWtvDtJeVhncrG7h-BhPkoHdhlOp6fskC33EpLTRZS-mpIldNmhMSPcThcEC2_GvmWWg-TAWyVBIwmNRpXuGcFXHYx"

enum YelpSortMode: String {
    case best_match, rating, review_count, distance
}

class YelpClient: AFHTTPRequestOperationManager {
    var apiKey: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(yelpAPIKey: yelpAPIKey)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(yelpAPIKey: String) {
        self.apiKey = yelpAPIKey
        
        let baseUrl = URL(string: "https://api.yelp.com/v3/")
        super.init(baseURL: baseUrl)
        requestSerializer.setValue("Bearer \(self.apiKey!)", forHTTPHeaderField: "Authorization")
    }
    
    func searchWithTerm(_ term: String, location: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, location: location, sort: nil, categories: nil, openNow: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, location: String, sort: YelpSortMode?, categories: [String]?, openNow: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see https://www.yelp.com/developers/documentation/v3/business_search
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "location": location as AnyObject]
        
        if sort != nil {
            parameters["sort_by"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["categories"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if openNow != nil {
            parameters["open_now"] = openNow! as AnyObject
        }
        
        return self.get("businesses/search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}
