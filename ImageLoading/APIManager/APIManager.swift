//
//  APIManager.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import UIKit
import Combine

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case noData
    case invalidBody
    case invalidJSON
}

final class APIManager {
    var latestTaskId: String = ""
    var latestTask: URLSessionDataTask?
    
    private static let sessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        // For each task, load image from cache, otherwise load from server
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return configuration
    }()
    
    private static let session: URLSession = {
        let session =  URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    static func cancelAllTasks() {
        session.invalidateAndCancel()
    }
    
    func configure(from imgPath: String, completionHandler: @escaping ((UIImage?) -> ()) ) {
        guard let url = URL(string: imgPath) else { return }
        // Keep an history of the request.
        latestTaskId = UUID().uuidString
        let checkTaskId = latestTaskId
        
        // cancel the old task.
        // We don't set the reference of latestTask to nil, so that the session can still work with it.
        (latestTask != nil) ? latestTask?.cancel() : ()

        // Download the image asynchronously
        latestTask = Self.session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    if(self.latestTaskId == checkTaskId) {
                        completionHandler(nil)
                    }
                }
                print(err)
                return
            }
            
            // Return the image, only if taskId match
            DispatchQueue.main.async {
                if let data = data,
                   let image = UIImage(data: data) {
                    // Compare the id from the class scope, with the id of the method scope
                    if (self.latestTaskId == checkTaskId) {
                        completionHandler(image)
                    }
                } else {
                    if (self.latestTaskId == checkTaskId) {
                        completionHandler(nil)
                    }
                }
            }
        }
        latestTask?.resume()
    }
    
    func request() -> AnyPublisher<[ImageModel], Error> {
        // Construct URL
        let webURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
        guard let url = URL(string: webURL) else {
            return Fail(error: NSError(domain: APIError.invalidURL.localizedDescription, code: 1)).eraseToAnyPublisher()
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create data task
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    print(URLError(.badServerResponse))
                    print(output.response)
                    throw URLError(.badServerResponse)
                }
                print(output.response)
                return output.data
            }
            .decode(type: [ImageModel].self, decoder: JSONDecoder())
            .mapError { error in
                print(error.localizedDescription)
                return NSError(domain: APIError.invalidJSON.localizedDescription, code: 2)
            }
            .eraseToAnyPublisher()
    }
}

