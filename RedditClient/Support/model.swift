//
//  model.swift
//  RedditClient
//
//  Created by Matt Bommer on 2/18/21.
//

import Foundation

struct Listing: Decodable {
    let children: [Kind<Post>]
    let after: String
}

struct Kind<T: Decodable>: Decodable {
    let kind: String
    let data: T
}

struct Post: Decodable {
    let title: String
    let author: String
    let url: String
    let thumbnail: String
    let subreddit: String
    let id: String
}

struct SubredditNames: Decodable {
    let names: [String]
}
