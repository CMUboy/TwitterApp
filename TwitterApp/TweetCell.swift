//
//  TweetCell.swift
//  TwitterApp
//
//  Created by Joseph Ku on 2/22/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet? {
        get {
            return self.tweet
        }
        set(tweet) {
            self.profileImageView.setImageWithURL(NSURL(string: tweet!.user!.profileImageUrl!))
            self.nameLabel.text = tweet!.user!.name
            self.screenNameLabel.text = "@\(tweet!.user!.screenName!)"
            self.tweetTextLabel.text = tweet!.text
            self.timestampLabel.text = tweet!.createdAt!.timeAgo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
