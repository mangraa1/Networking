//
//  MainViewController.swift
//  Networking
//
//  Created by mac on 05.09.2023.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case courses = "Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case coursesAlamofire = "Courses (Alamofire)"
    case responseData = "responseData"
    case responseString = "responseString"
    case response = "response"
}

class MainViewController: UICollectionViewController {

    //MARK: @IBOutlets & Variables

    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImageURL = "https://api.imgur.com/3/image"
    private let swiftbookAPI = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

    private let actions = Actions.allCases
    private let dataProvider = DataProvider()
    private var filePath: String?

    private var alert: UIAlertController!

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerForNotification()

        dataProvider.fileLocation = { location in
            // Saving file
            print("Download finished \(location.absoluteURL)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }

    //MARK: - Private

    private func showAlert() {
        alert = UIAlertController(title: "Downloading ...", message: "0%", preferredStyle: .alert)

        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dataProvider.stopDownload()
        }

        alert.addAction(cancelAction)
        present(alert, animated: true) {

            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                                y: self.alert.view.frame.height / 2 - size.height / 2)

            let actitvityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            actitvityIndicator.color = .gray
            actitvityIndicator.startAnimating()

            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .systemBlue
            self.dataProvider.onProgress = { progress in

                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }

            [actitvityIndicator, progressView].forEach { self.alert.view.addSubview($0) }
        }
    }

    // MARK: - UICollectionViewDataSource

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

    // MARK: - UICollectionViewDelegate

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
            NetworkManager.uploadImage(url: uploadImageURL)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .coursesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "ResponseData", sender: self)
            AlamofireNetworkRequest.responseDataFromAPI(url: swiftbookAPI)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: swiftbookAPI)
        case .response:
            AlamofireNetworkRequest.response(url: swiftbookAPI)
        }
    }

    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController

        switch segue.identifier {
        case "OurCourses":
            coursesVC?.fetchData()
        case "OurCoursesWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "ShowImage":
            imageVC?.fetchImage()
        case "ResponseData":
            imageVC?.fetchDataWithAlamofire()
        default:
            break
        }
    }
}

extension MainViewController {

    private func registerForNotification() {

        UNUserNotificationCenter.current().requestAuthorization { _, _ in }
    }

    private func postNotification() {

        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path: \(filePath ?? "")"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
