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
    private let largeImageURL = "https://i.imgur.com/3416rvI.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        progressLabel.isHidden = true
        progressView.isHidden = true
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

        AlamofireNetworkRequest.downloadImage(url: url) { image in
            sleep(1)
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }

    public func downloadImageWithProgress() {

        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }

        AlamofireNetworkRequest.completed = { completed in
            self.progressLabel.isHidden = false
            self.progressLabel.text = completed
        }

        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageURL) { image in
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
        }
    }
}
