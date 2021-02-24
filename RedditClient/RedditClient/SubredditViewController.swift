//
//  SubredditViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import UIKit
import SafariServices

class SubredditViewController: UITableViewController, UITabBarControllerDelegate, RequestBuilder {

    @IBInspectable var subredditName: String = ""
    let mainClient: APIClient = APIClient()
    var posts: [Post] = []
    var sortEndpoint: SortCategory?
    var afterId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "r/\(subredditName)"
        self.tabBarController?.delegate = self
        
        let sortImage = UIImage(systemName: "arrow.up.arrow.down.circle")
        let sortButton = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(showSortOptions))

        self.navigationItem.rightBarButtonItem = sortButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestListingData(discardPostData: false)
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
            requestListingData(discardPostData: false)
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle(for: PostTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    private func requestListingData(discardPostData: Bool) {
        guard let url = fetchUrl(endpoint: .subreddit(sub: self.subredditName), apiParamters: .subreddit(afterId: self.afterId, count: self.posts.count), sortEndpoint: self.sortEndpoint) else {
            fatalError("An error occurred while trying to create the API URL.")
        }
        let request = URLRequest(url: url)
        mainClient.performDecodable(request: request) { (result: Result<Kind<Listing>, Error>) in
            switch result {
            case .success(let kind):
                let kindMapping = kind.data.children.map { return $0.data }
                if discardPostData {
                    self.posts = kindMapping
                }else {
                    self.posts.append(contentsOf: kindMapping)
                }
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
    
    public func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    private func refreshPostDataByEndpoint(endpoint: SortCategory) {
        sortEndpoint = endpoint
        afterId = nil
        requestListingData(discardPostData: true)
    }
    
    @objc
    func showSortOptions() {
        let alertController = UIAlertController(title: "Sort By..." , message: nil, preferredStyle: .actionSheet)
        for action in SortCategory.allCases {
            alertController.addAction(UIAlertAction(title: action.rawValue, style: .default) { (alertAction) in
                guard let actionTitle = alertAction.title, let sortCategory = SortCategory(rawValue: actionTitle) else {
                    return
                }
                self.refreshPostDataByEndpoint(endpoint: sortCategory)
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
