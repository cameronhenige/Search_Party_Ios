
import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let gcmMessageIDKey = "gcm.message_id"
    weak var searchPartyAppState: SearchPartyAppState?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)
        
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

        //todo see if i need this code here
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
        UserDefaults.standard.setValue(fcmToken, forKey: "LATEST_FCM_TOKEN")

        if(Auth.auth().currentUser != nil){
            self.updateUsersFcmToken(token: fcmToken!)
        }else{
            
        }
    }
    
        private func updateUsersFcmToken(token: String) {
                        
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("fcmTokens").document(token).setData([
                "token": token, "os": "iOS"
            ], merge: true) { err in
                if let err = err {
                    print("Error saving latest token: \(err)")
                } else {
                    UserDefaults.standard.setValue(token, forKey: token + "_" + Auth.auth().currentUser!.uid)
                }
            }
            }
    

    
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
        print("did receive" + userInfo.debugDescription)

      Messaging.messaging().appDidReceiveMessage(userInfo)
      var messageType = userInfo["messageType"]
      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo

        let lostPetId = userInfo["lostPetId"] as! String
        let messageType = userInfo["messageType"] as! String
        let lostPetname = userInfo["lostPetName"]
        let message = userInfo["message"]

      Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if(messageType == "1"){
            searchPartyAppState?.navigateToLostPet(lostPetId: lostPetId, goToChat: false)
        }else if(messageType == "2") {
            searchPartyAppState?.navigateToLostPet(lostPetId: lostPetId, goToChat: false)
        }else if(messageType == "3") {
            searchPartyAppState?.navigateToLostPet(lostPetId: lostPetId, goToChat: true)
        }else if(messageType == "4") {
            searchPartyAppState?.navigateToLostPet(lostPetId: lostPetId, goToChat: false)
        }
        
      completionHandler()
    }

}
