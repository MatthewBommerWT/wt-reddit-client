//
//  SubredditViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import UIKit

class SubredditViewController: UITableViewController {

    let baseAPIURL: String =  "https://reddit.com/.json"
    let mainClient: APIClient = APIClient()
        
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
                print(kind)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show the post that has been selected
    }

}
