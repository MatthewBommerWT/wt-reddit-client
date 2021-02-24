//
//  SubredditSearchViewController.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/23/21.
//

import UIKit

class SubredditSearchViewController: UITableViewController, UISearchResultsUpdating, RequestBuilder {

    var subredditSearchController = UISearchController(searchResultsController: nil)
    let mainClient: APIClient = APIClient()
    var searchResults: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subredditSearchController.searchResultsUpdater = self
        subredditSearchController.searchBar.placeholder = "Search for Subreddit"
        subredditSearchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = subredditSearchController
        navigationItem.title = "Explore Other Subreddits"
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell")!
        cell.textLabel?.text = searchResults[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let subredditViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubredditViewController") as! SubredditViewController
        subredditViewController.subredditName = searchResults[indexPath.item]
        self.navigationController?.pushViewController(subredditViewController, animated: false)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let subredditQuery = searchController.searchBar.text else {
            return
        }
        
        guard let url = fetchUrl(endpoint: .search, apiParamters: .search(query: subredditQuery), sortEndpoint: nil) else {
            return
        }
        requestSearchData(url: url)
        
    }
    
    private func requestSearchData(url: URL) {
        let request = URLRequest(url: url)
        mainClient.performDecodable(request: request) { (result: Result<SubredditNames, Error>) in
            switch result {
            case .success(let subredditList):
                self.searchResults = subredditList.names
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
