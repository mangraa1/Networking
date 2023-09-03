//
//  CoursesViewController.swift
//  Networking
//
//  Created by mac on 02.09.2023.
//

import UIKit

class CoursesViewController: UITableViewController {

    //MARK: Variables

    private var courses = [Course]()

    //MARK: - Life Cycle

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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.courses = try decoder.decode([Course].self, from: data)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }

    private func configureCell(_ cell: CoursesViewCell, for indexPath: IndexPath) {

        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name

        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons \(numberOfLessons)"
        }

        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests \(numberOfTests)"
        }

        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as? CoursesViewCell else { fatalError() }

        configureCell(cell, for: indexPath)

        return cell
    }

    //MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
