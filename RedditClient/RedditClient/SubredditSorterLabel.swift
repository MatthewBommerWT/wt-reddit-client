//
//  SubredditSorterLabel.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/22/21.
//

import UIKit

class SubredditSorterLabel: UILabel {

    private let alertController = UIAlertController(title: "Sort By..." , message: nil, preferredStyle: .actionSheet)
    private let categories = ["hot", "new", "top", "rising", "random", "controversial"]
    var delegate: SubredditViewController
    
    init(parentViewController: UIViewController) {
        self.delegate = parentViewController as! SubredditViewController
        
        super.init(frame: CGRect())
        self.text = "r/Aww"
        self.sizeToFit()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        setupAlertController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAlertController() {
        for action in categories {
            alertController.addAction(UIAlertAction(title: action, style: .default) { (alertAction) in
                guard let actionTitle = alertAction.title else {
                    return
                }
                self.delegate.refreshPostDataByEndpoint(endpoint: actionTitle)
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) 
    }
    
    @objc
    func labelTapped(sender: UITapGestureRecognizer) {
        self.delegate.present(alertController, animated: true, completion: nil)
    }
    
}
