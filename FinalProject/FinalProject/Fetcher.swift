//
//  Fetcher.swift
//  FinalProject
//
//  Created by Sonny Huang  on 7/31/19.
//  Copyright © 2019 Harvard University. All rights reserved.
//


import Foundation

class Fetcher: NSObject, URLSessionDelegate {
    static var session: URLSession {
        return URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: Fetcher(),
            delegateQueue: nil
        )
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {        NSLog("\(#function): Session received authentication challenge")
        completionHandler(.performDefaultHandling, nil)
    }
}

extension String: Error {}

struct DataTaskCompletion {
    var data: Data?
    var response: URLResponse?
    var netError: Error?
}


extension Fetcher {
    typealias CompletionHandler = (Result<Data,String>) -> Void
    static func fetch(url: URL, completion: @escaping CompletionHandler) {
        let task = session
            .dataTask(with: url) { (data: Data?, response: URLResponse?, netError: Error?) in
                guard let response = response as? HTTPURLResponse, netError == nil else {
                    return completion(.failure(netError!.localizedDescription))
                }
                guard response.statusCode == 200 else {
                    return completion(.failure("\(response.description)"))
                }
                guard let data = data  else {
                    return completion(.failure("valid response but no data"))
                }
                completion(.success(data))
        }
        task.resume()
    }
    
    typealias RawCompletionHandler = (Result<DataTaskCompletion, String>) -> Void
    static func fetchRaw(url: URL, completion: @escaping RawCompletionHandler) {
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, netError: Error?) in
            let result = DataTaskCompletion(data: data, response: response, netError: netError)
            completion(.success(result))
            }
            .resume()
    }
    
}

