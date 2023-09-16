//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by mac on 11.09.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {

    static var onProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?

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

    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {

        guard let url = URL(string: url) else { return }

        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    completion(image)
                }

            case .failure(let error):
                print("Error: \(error)")
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

    static func downloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage) -> ()) {

        guard let url = URL(string: url) else { return }

        AF.request(url)
            .validate()
            .downloadProgress { progress in

                print("totalUnitCount: ", progress.totalUnitCount)
                print("completedUnitCount: ", progress.completedUnitCount)
                print("fractionCompleted: ", progress.fractionCompleted)
                print("localizedDescription: ", progress.localizedDescription ?? "")
                print("-------------------------------")

                self.onProgress?(progress.fractionCompleted)
                self.completed?(progress.localizedDescription)
            }
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        completion(image)
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }


    static func postRequest(url: String, completion: @escaping (_ courses: [CourseModel]) -> ()) {
        guard let url = URL(string: url) else { return }

        let userData: [String: Any] = ["name": "Network Request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2020/03/12-course-copy-15.jpg",
                                       "numberfLessons": 18,
                                       "numberOfTests": 10]

        AF.request(url, method: .post, parameters: userData).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("Status code: \(statusCode)")

            switch response.result {
            case .success(let data):

                // Converting data into json for creating a course model
                if let data = data {
                    do {
                        if let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            guard let course = CourseModel(json: jsonDictionary) else { return }

                            var courses = [CourseModel]()
                            courses.append(course)

                            completion(courses)
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
