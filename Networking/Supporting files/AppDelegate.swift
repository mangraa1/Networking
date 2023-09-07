//
//  AppDelegate.swift
//  Networking
//
//  Created by mac on 29.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var bgSessionCompletionHandler: (() -> ())?

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {

        bgSessionCompletionHandler = completionHandler
    }
}

