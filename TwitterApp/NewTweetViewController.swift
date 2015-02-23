//
//  NewTweetViewController.swift
//  TwitterApp
//
//  Created by Joseph Ku on 2/23/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class NewTweetViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var user: User?
    var newTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!))
        self.nameLabel.text = user!.name
        self.screenNameLabel.text = "@\(user!.screenName!)"
        self.tweetTextView.becomeFirstResponder()
        
        self.newTweet = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "TweetTweetDetail" {
            self.newTweet = Tweet()
            newTweet!.user = user
            newTweet!.text = tweetTextView.text
        }
    }

}
