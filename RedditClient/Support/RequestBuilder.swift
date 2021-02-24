//
//  RequestBuilder.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/23/21.
//

import Foundation
import UIKit

enum RedditEndpoints {
    case subreddit(sub: String)
    case search
}

enum RedditEndpointParameters {
    case subreddit(afterId: String?, count: Int)
    case search(query: String?)
}

protocol RequestBuilder{
    func fetchQueryParameters(endpointParameters: RedditEndpointParameters) -> [URLQueryItem]
    func fetchUrl(endpoint: RedditEndpoints, apiParamters: RedditEndpointParameters, sortEndpoint: SortCategory?) -> URL?
    func buildUrlString(endpoint: RedditEndpoints, sortEndpoint: SortCategory?) -> String
}

extension RequestBuilder {
    func fetchQueryParameters(endpointParameters: RedditEndpointParameters) -> [URLQueryItem] {
        switch endpointParameters {
        case .subreddit(let afterId, let count):
            return [URLQueryItem(name: "after", value: afterId), URLQueryItem(name: "count", value: String(count))]
        case .search(let query):
            return [URLQueryItem(name: "query", value: query), URLQueryItem(name: "include_over_18", value: "false")]
        }
    }
    
    func fetchUrl(endpoint: RedditEndpoints, apiParamters: RedditEndpointParameters, sortEndpoint: SortCategory?) -> URL? {
        let urlString = buildUrlString(endpoint: endpoint, sortEndpoint: sortEndpoint)
        guard var url = URLComponents(string: urlString) else {
            fatalError("Base api url \(urlString) is not correct")
        }
        url.queryItems = fetchQueryParameters(endpointParameters: apiParamters)
        return url.url
    }
    
    func buildUrlString(endpoint: RedditEndpoints, sortEndpoint: SortCategory?) -> String {
        let redditBaseAPIURL = "https://www.reddit.com/"
        switch endpoint {
        case RedditEndpoints.subreddit(let sub):
            let urlString = redditBaseAPIURL + redditize(sub)
            guard let endpoint = sortEndpoint else {
                return "\(urlString).json"
            }
            return "\(urlString + endpoint.rawValue).json"
        case .search:
            return "\(redditBaseAPIURL)api/search_reddit_names.json"
        }
    }
    
    func redditize(_ sub: String) -> String{
        return "r/\(sub)/"
    }
}
