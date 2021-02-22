//
//  TabBarViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/22/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let delegate = self.delegate as! SubredditViewController
        delegate.scrollToTop()
    }
}
