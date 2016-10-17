//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    var mentionsList = [Array<Mention>]()
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            mentionsList.append(tweet.hashtags)
            mentionsList.append(tweet.urls)
            mentionsList.append(tweet.userMentions)
            
            var mentionColor = UIColor.clearColor()
            
            for mentions in mentionsList {
                switch mentions {
                case _ where mentions == tweet.hashtags:
                    mentionColor = UIColor.blueColor()
                case _ where mentions == tweet.urls:
                    mentionColor = UIColor.redColor()
                case _ where mentions == tweet.userMentions:
                    mentionColor = UIColor.brownColor()
                default: break
                }

                for mention in mentions {
                    (tweetTextLabel?.attributedText as? NSMutableAttributedString)?.addAttribute(
                        NSForegroundColorAttributeName, value: mentionColor, range: mention.nsrange)
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
    
}
