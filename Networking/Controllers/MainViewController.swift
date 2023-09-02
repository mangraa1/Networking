//
//  ViewController.swift
//  Networking
//
//  Created by mac on 29.08.2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - @IBActions

    @IBAction func getRequest(_ sender: Any) {

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

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

    @IBAction func postRequest(_ sender: Any) {

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

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
}

