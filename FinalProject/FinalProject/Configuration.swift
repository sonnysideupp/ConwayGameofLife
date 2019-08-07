//
//  Configuration.swift
//  FinalProject
//
//  Created by Sonny Huang  on 7/31/19.
//  Copyright © 2019 Harvard University. All rights reserved.
//

import Foundation

struct Configuration : Codable {
    static let ConfigurationURL = URL(string: "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1")!
    typealias CompletionHandler = (Result<[Configuration],String>) -> Void
    
    let title : String?
    let contents: [[Int]]?
    
    private enum CodingKeys : String, CodingKey {
        case title = "title"
        case contents = "contents"
    }
    
    static func fetch(
        url: URL = Configuration.ConfigurationURL,
        completion: @escaping Configuration.CompletionHandler
        ) -> Void {
        Fetcher.fetch(url: url) { (result: Result<Data, String>) in
            guard case .success(let data) = result else {
                let _ = result.mapError { errMsg -> String in
                    completion(Result.failure(errMsg))
                    return errMsg
                }
                return
            }
            do {
                let configs = try JSONDecoder().decode([Configuration].self, from: data)
                completion(Result.success(configs))
            } catch {
                completion(Result.failure(error.localizedDescription))
            }
        }
    }
}
