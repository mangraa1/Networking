//
//  CoursesViewController.swift
//  Networking
//
//  Created by mac on 02.09.2023.
//

import UIKit

class CoursesViewController: UITableViewController {

    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }

    //MARK: - Private

    private func fetchData() {

       let jsonURLString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

        guard let url = URL(string: jsonURLString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as? CoursesViewCell else { fatalError() }

        return cell
    }

    //MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
