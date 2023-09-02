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
