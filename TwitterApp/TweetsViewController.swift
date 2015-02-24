//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Joseph Ku on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetsViewController: UITableViewController {
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        reloadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onRefresh() {
        reloadTableData()
    }

    private func reloadTableData() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) {
            (tweets: [Tweet]?, error: NSError?) in
            if tweets != nil {
                self.tweets = tweets!
                self.tableView.reloadData()
                if (self.refreshControl!.refreshing) {
                    self.refreshControl!.endRefreshing()
                }
            } else {
                // handle error
            }
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser!.logout()
    }
    
    @IBAction func cancelToTweetsViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func tweetTweetDetail(segue:UIStoryboardSegue) {
        let vc = segue.sourceViewController as NewTweetViewController
        
        if let tweet = vc.newTweet {
            if let reply = vc.isReply {
                if reply {
                    TwitterClient.sharedInstance.replyWithCompletion(tweet) {
                        (tweet: Tweet?, error: NSError?) in
                        if tweet != nil {
                            self.tweets.insert(tweet!, atIndex: 0)
                            self.tableView.reloadData()
                        } else {
                            // handle error
                        }
                    }
                } else {
                    TwitterClient.sharedInstance.tweetWithCompletion(tweet) {
                        (tweet: Tweet?, error: NSError?) in
                        if tweet != nil {
                            self.tweets.insert(tweet!, atIndex: 0)
                            self.tableView.reloadData()
                        } else {
                            // handle error
                        }
                    }
                }
            }
        }
//
//        //add the new player to the players array
//        players.append(playerDetailsViewController.player)
//        
//        //update the tableView
//        let indexPath = NSIndexPath(forRow: players.count-1, inSection: 0)
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        
//        //hide the detail view controller
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DisplayTweetDetail" {
            let vc = segue.destinationViewController as TweetDetailViewController
            vc.tweet = tweets[tableView.indexPathForSelectedRow()!.row]
        }
        
        if segue.identifier == "NewTweet" {
            let vc = segue.destinationViewController as NewTweetViewController
            vc.user = User.currentUser
            vc.isReply = false
        }
    }

}
