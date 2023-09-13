//
//  ImageViewController.swift
//  Networking
//
//  Created by mac on 30.08.2023.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {

    //MARK: @IBOutlets & Variables

    private let url = "https://i.pinimg.com/736x/bf/ca/a8/bfcaa8d343fb043f6641f8b468c930d0.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }

    //MARK: - Public

    public func fetchImage() {

        NetworkManager.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }

    // Loading and displaying photo from the Internet
    public func fetchDataWithAlamofire() {

        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    sleep(1)
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
