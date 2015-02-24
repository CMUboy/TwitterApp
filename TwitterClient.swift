//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Joseph Ku on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

let twitterConsumerKey = "rMg8fXe1COmkbCRcPu4rCf9D7"
let twitterConsumerSecret = "NMJElnUfWTRw4FiyoinHVaV4eryPeJCtPKQj0lKlt8nvfQhNgO"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    var homeTimelineCompletion: ((tweets: [Tweet]?, error: NSError?) -> ())?
    var tweetCompletion: ((tweet: Tweet?, error: NSError?) -> ())?
    var replyCompletion: ((tweet: Tweet?, error: NSError?) -> ())?
    var retweetCompletion: ((tweet: Tweet?, error: NSError?) -> ())?
    var favoriteCompletion: ((tweet: Tweet?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                println("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: {(error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.homeTimelineCompletion = completion
        
        GET(
            "1.1/statuses/home_timeline.json",
            parameters: params,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                self.homeTimelineCompletion?(tweets: tweets, error: nil)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting home timeline.")
                self.homeTimelineCompletion?(tweets: nil, error: error)
            }
        )
    }
    
    // https://api.twitter.com/1.1/statuses/update.json
    
    func tweetWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.tweetCompletion = completion
        
        POST(
            "1.1/statuses/update.json",
            parameters: ["status": tweet.text!],
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                let newTweet: Tweet? = nil
                self.tweetCompletion?(tweet: newTweet, error: nil)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error updating status.")
                println(error)
                self.tweetCompletion?(tweet: nil, error: error)
            }
        )
    }

    // https://api.twitter.com/1.1/statuses/update.json
    
    func replyWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.replyCompletion = completion
        
        POST(
            "1.1/statuses/update.json",
            parameters: ["status": tweet.text!, "in_reply_to_status_id": tweet.idString!],
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                let newTweet: Tweet? = nil
                self.tweetCompletion?(tweet: newTweet, error: nil)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error updating status.")
                println(error)
                self.tweetCompletion?(tweet: nil, error: error)
            }
        )
    }
    
    // https://api.twitter.com/1.1/statuses/retweet/:id.json

    func retweetWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.retweetCompletion = completion
        
        POST(
            "1.1/statuses/retweet/\(tweet.idString!).json",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                let newTweet: Tweet? = nil
                self.retweetCompletion?(tweet: newTweet, error: nil)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error updating status.")
                println(error)
                self.retweetCompletion?(tweet: nil, error: error)
            }
        )
    }

    // https://api.twitter.com/1.1/favorites/create.json?id=243138128959913986
    
    func favoriteWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.favoriteCompletion = completion
        
        POST(
            "1.1/favorites/create.json?id=\(tweet.idString!)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                let newTweet: Tweet? = nil
                self.favoriteCompletion?(tweet: newTweet, error: nil)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error updating status.")
                println(error)
                self.favoriteCompletion?(tweet: nil, error: error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                println("Got the access token")
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET(
                    "/1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        let user = User(dictionary: response as NSDictionary)
                        User.currentUser = user
                        println("User: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("Error getting current user.")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
            },
            failure: {(error: NSError!) -> Void in
                println("Failed to get access token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
        
    }
}
