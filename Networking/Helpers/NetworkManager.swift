//
//  NetworkManager.swift
//  Networking
//
//  Created by mac on 05.09.2023.
//

import UIKit

class NetworkManager {

    static func getRequest(url: String) {

        guard let url = URL(string: url) else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            guard let response = response,
                  let data = data
                  else { return }

            print(response)
            print(data)

            // Converting data from one format to another to get data
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }

        }.resume()
    }

    static func postRequest(url: String) {
        guard let url = URL(string: url) else { return }

        let userData = ["Project": "Networking", "Commit": "Sixth"]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData) else { return }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let response = response, let data = data else { return }

            print(response)

            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    // For ImageVC
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    sleep(1)
                    completion(image)
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    // For CoursesVC
    static func fetchData(url: String, completion: @escaping (_ courses: [CourseModel]) -> ()) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([CourseModel].self, from: data)
                completion(courses)

            } catch let error {
                print("Error serialization json", error)
            }

        }.resume()
    }

    static func uploadImage(url: String) {

        let image = UIImage(named: "Network")!
        let httpHeaders = ["Authorization": "Client-ID f2fe396cec43751"]

        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }

        guard let url = URL(string: url) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data // Data to send

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
