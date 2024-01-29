//
//  AppDelegate.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import FirebaseCore
import GoogleSignIn
import FacebookCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      ApplicationDelegate.shared.application(
          application,
          didFinishLaunchingWithOptions: launchOptions
      )

      FacebookCore.Settings.setAdvertiserTrackingEnabled(false)
      FirebaseApp.configure()
      return true
  }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)
    }
}
