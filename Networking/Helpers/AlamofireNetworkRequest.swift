//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by mac on 11.09.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {

    // To display courses in the tableView in CoursesVC
    static func sendRequest<T: Decodable>(url: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
            }

        AF.request(url, method: .get).responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value)) // Process a successful response and transmit the decoded data
            case .failure(let error):
                completion(.failure(error)) // Error handling
            }
        }
    }

    // Print all courses contained on the site
    static func responseDataFromAPI(url: String) {

        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    // Print all courses contained on the site
    static func responseString(url: String) {

        AF.request(url).responseString { responseString in
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }

    // Print all courses contained on the site
    static func response(url: String) {

        AF.request(url).response { response in
            guard let data = response.data,
                  let string = String(data: data, encoding: .utf8)
                  else { return }

            print(string)
        }
    }
}
