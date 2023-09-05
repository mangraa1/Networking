//
//  MainViewController.swift
//  Networking
//
//  Created by mac on 05.09.2023.
//

import UIKit

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case courses = "Courses"
    case uploadImage = "Upload Image"
}

class MainViewController: UICollectionViewController {

    //MARK: @IBOutlets & Variables

    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let actions = Actions.allCases

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ControlCell", for: indexPath) as! ControlsViewCell

        cell.label.text = actions[indexPath.row].rawValue

        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let action = actions[indexPath.row]

        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .courses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            print("Upload Image")
        }
    }
}
