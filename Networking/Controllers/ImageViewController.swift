//
//  ImageViewController.swift
//  Networking
//
//  Created by mac on 30.08.2023.
//

import UIKit

class ImageViewController: UIViewController {

    //MARK: @IBOutlets & Variables

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true

        fetchImage()
    }

    //MARK: - Private

    private func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        guard let url = URL(string: "https://i.pinimg.com/736x/bf/ca/a8/bfcaa8d343fb043f6641f8b468c930d0.jpg") else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    sleep(1)
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
