//
//  DataProvider.swift
//  Networking
//
//  Created by mac on 07.09.2023.
//

import UIKit

class DataProvider: NSObject {

    //MARK: Variables

    private var downloadTask: URLSessionDownloadTask!
    public var fileLocation: ((URL) -> ())?
    public var onProgress: ((Double) -> ())?
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "Heorhii.Networking")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true // Transfer to the background at the end of the download

        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    //MARK: - Public

    public func startDownload() {

        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(1)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024 // 100MB
            downloadTask.resume()
        } else {
            print("Error creating URL")
        }
    }

    public func stopDownload() {
        downloadTask.cancel()
    }
}

//MARK: - URLSessionDelegate
extension DataProvider: URLSessionDelegate {

    // Called when all events for the background URLSession have ended.
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else { return }

            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("error")
    }
}

//MARK: - URLSessionDownloadDelegate
extension DataProvider: URLSessionDownloadDelegate {

    // Called after a file upload has successfully completed.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")

        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }

    // Tracking the progress of data loading during the loading task
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard totalBytesWritten != NSURLSessionTransferSizeUnknown else { return }

        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")

        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
