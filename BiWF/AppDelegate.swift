//
//  AppDelegate.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/16/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import AppAuth
import FirebaseCrashlytics
import Pendo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    /**
     An AppAuth property to hold the session, in order to continue the authorization flow from the redirection.
     */
    var currentAuthorizationFlow: OIDExternalUserAgentSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        PendoAnalyticsManager.configure()
    

        if #available(iOS 13.0, *) {
            // iOS 13 will utilize the SceneDelegate
        } else {
            // Initialize dependencies to be injected
            let navController = RootNavigationController()
            let coordinator = MainCoordinator(navigationController: navController)
            coordinator.start()

            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        for window in application.windows {
            if type(of: window).description() == "SCSAttachmentWindow" {
                window.windowLevel = UIWindow.Level(0.1)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TokenManager.shared.refreshToken()
    }
}
