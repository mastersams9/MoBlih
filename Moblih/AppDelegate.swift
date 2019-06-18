//
//  AppDelegate.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var eventInput: AuthenticationInteractorEventInput?
    var appRouter: AppRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        appRouter = AppRouter(keychainWrapper: KeychainWrapper())

        window?.rootViewController = appRouter?.makeViewController(eventInput: &eventInput)
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        eventInput?.handleUrl(url)
        return false
    }
}

private struct GithubAPIRepositoryCreationRequest: GithubAPIRepositoryCreationRequestProtocol {
    var name: String
    var description: String?
    var isPrivate: Bool
    var isReadmeAutoInit: Bool
}
