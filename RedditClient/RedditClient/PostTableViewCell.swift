//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/19/21.
//

import UIKit
import AlamofireImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(for post: Post) {
        postLabel.text = post.title
        postAuthor.text = "By: \(post.author)"
        guard let url = URL(string: post.thumbnail) else {
            return
        }
        
        postImage.af.setImage(withURL: url)
    }
    
    override func prepareForReuse() {
        postLabel.text = nil
        postAuthor.text = nil
        postImage.image = nil
    }
}
