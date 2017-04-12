//
//  yelpClient.swift
//  letsEat
//
//  Created by Prashant Bhandari on 4/3/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import YelpAPI
import Alamofire

let client_id = "ClientID"
let client_secret = "ClientSecret"

class yelpClient: NSObject {

    static var accessToken: String?
    static var tokenType: String?


    class func getAccessToken() {
        let parameters: Parameters = ["client_id": client_id, "client_secret": client_secret]
        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).response {
            response in
            print("Request: \((response.request)!)")
            print("Response: \((response.response)!)")

            if let data = response.data {
                let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                print("Access Token: \((dict["access_token"])!)")
                self.accessToken = (dict["access_token"])! as? String
                self.tokenType = (dict["token_type"])! as? String
                getRestaurents(searchTerm: "Restaurants")
            }
        }
    }

    class func getRestaurents(searchTerm: String) {
        let parameters: Parameters = ["term": searchTerm as AnyObject]
//        let headers: HTTPHeaders = [tokenType!: accessToken!] ?latitude=37.786882&longitude=-122.399972
        Alamofire.request("https://api.yelp.com/v3/businesses/search?location=WashingtonDC", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer AccessToken"]).response {
            response in
            if let data = response.data {
                let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                print("dict: \(dict)")
            }
        }
    }

    class func searchYelp() {
        let query = YLPQuery(location: "Washington DC, DC")
        query.term = "restaurants"
        query.limit = 20

        YLPClient.authorize(withAppId: client_id, secret: client_secret) { (success: YLPClient?, error: Error?) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            }
            else {
                success?.search(with: query, completionHandler: { (respond: YLPSearch?, error: Error?) in
                    if error != nil {
                        print("error: \(String(describing: error?.localizedDescription))")
                    }
                    else {
                        let businesses = (respond?.businesses)! as [YLPBusiness]
                        for business in businesses {
                            print(business.name)
                        }
                    }
                })
            }
        }
    }


}
