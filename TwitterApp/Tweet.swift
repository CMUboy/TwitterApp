//
//  Tweet.swift
//  TwitterApp
//
//  Created by Joseph Ku on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var idString: String?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeted: Bool?
    var retweetCount: UInt?
    var favorited: Bool?
    var favoriteCount: UInt?
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        println(dictionary)
        
        idString = dictionary["id_str"] as String?
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = dictionary["retweet_count"] as? UInt
        favorited = dictionary["favorited"] as? Bool
        favoriteCount = dictionary["favorite_count"] as? UInt
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map { Tweet(dictionary: $0) }
    }
}
