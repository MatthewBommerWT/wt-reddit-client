//
//  SubredditViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import UIKit

class SubredditViewController: UITableViewController {

    let baseAPIURL: String =  "https://www.reddit.com/r/aww/.json"
    let mainClient: APIClient = APIClient()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let url = URL(string: baseAPIURL) else {
            fatalError("Base api url \(baseAPIURL) is not correct")
        }
        let request = URLRequest(url: url)
        mainClient.performDecodable(request: request) { (result: Result<Kind<Listing>, Error>) in
            switch result {
            case .success(let kind):
                self.posts = kind.data.children.map { return $0.data }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.posts)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show the post that has been selected
    }
    
    
}
