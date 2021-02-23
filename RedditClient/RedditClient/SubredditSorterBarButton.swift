//
//  SubredditSorterLabel.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/22/21.
//

import UIKit

enum SortCategory: String, CaseIterable {
    case hot
    case new
    case top
    case rising
    case random
    case controversial
}

protocol SubredditSortHandler: class {
    func showSortOptions()
}

class SubredditSorterBarButton: UIBarButtonItem {

    weak var handler: SubredditSortHandler?
    
    override init() {
        super.init()
        self.image = UIImage(systemName: "arrow.up.arrow.down.circle")
        self.action = #selector(presentSortCategories)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func inject(handler: SubredditSortHandler) {
        self.handler = handler
    }
    
    @objc
    func presentSortCategories() {
        self.handler?.showSortOptions()
    }
}
