//
//  SubredditViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import UIKit
import SafariServices

class SubredditViewController: UITableViewController, UITabBarControllerDelegate {

    let baseAPIURL: String =  "https://www.reddit.com/r/aww/"
    let mainClient: APIClient = APIClient()
    var posts: [Post] = []
    var sortEndpoint: String?
    var afterId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "r/Aww"
        self.tabBarController?.delegate = self
        let sortLabel = SubredditSorterLabel(parentViewController: self)
        self.navigationItem.titleView = sortLabel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestListingData()
    }
    
    //MARK: -UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.item]
        cell.configure(for: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        guard let url = URL(string: post.url) else {
            print("There was an error getting the URL")
            return
        }
        
        let webViewController = SFSafariViewController(url: url)
        present(webViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == posts.count - 1 {
            requestListingData()
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle(for: PostTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    private func requestListingData() {
        guard let url = fetchUrl() else {
            fatalError("An error occurred while trying to create the API URL.")
        }
        let request = URLRequest(url: url)
        mainClient.performDecodable(request: request) { (result: Result<Kind<Listing>, Error>) in
            switch result {
            case .success(let kind):
                self.posts.append(contentsOf: kind.data.children.map { return $0.data })
                self.afterId = kind.data.after
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.posts)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUrl() -> URL? {
        let queryItems = [URLQueryItem(name: "after", value: afterId), URLQueryItem(name: "count", value: String(posts.count))]
        let urlString = endpointConcat()
        guard var url = URLComponents(string: urlString) else {
            fatalError("Base api url \(urlString) is not correct")
        }
        url.queryItems = queryItems
        return url.url
    }
    
    private func endpointConcat() -> String {
        guard let endpoint = sortEndpoint else {
            return "\(baseAPIURL).json"
        }
        return "\(baseAPIURL + endpoint).json"
    }
    
    public func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    public func refreshPostDataByEndpoint(endpoint: String) {
        sortEndpoint = endpoint
        posts = []
        afterId = nil
        
        requestListingData()
    }
}
