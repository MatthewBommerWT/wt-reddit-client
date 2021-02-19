//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/19/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(for post: Post) {
        postLabel.text = post.title
        postImage
    }
    
}
