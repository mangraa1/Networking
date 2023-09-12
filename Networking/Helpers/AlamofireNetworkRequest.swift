//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by mac on 11.09.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {

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
}
