//
//  AppDelegate.swift
//  Networking
//
//  Created by mac on 29.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var bgSessionCompletionHandler: (() -> ())?

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {

        print("appDelegate")
        bgSessionCompletionHandler = completionHandler
    }
}

