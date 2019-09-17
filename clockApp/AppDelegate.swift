//
//  AppDelegate.swift
//  clockApp
//
//  Created by Gemini on 2019/08/27.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //バックグラウンドで行いたい処理があるとき
        backgroundTaskID = application.beginBackgroundTask {
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications: [UNNotification]) in
            for notification in notifications {
                _ = AlarmVC.shared.getAlarm(from: notification.request.identifier)
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(self.backgroundTaskID)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
        let uuid = notification.request.identifier
        _ = AlarmVC.shared.getAlarm(from: uuid)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        
        if identifier == "snooze"{
            let snoozeAction = UNNotificationAction(
                identifier: "snooze",
                title: "Snooze 5 Minutes",
                options: []
            )
            let noAction = UNNotificationAction(
                identifier: "stop",
                title: "stop",
                options: []
            )
            let alarmCategory = UNNotificationCategory(
                identifier: "alarmCategory",
                actions: [snoozeAction, noAction],
                intentIdentifiers: [],
                options: [])
            UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
            let content = UNMutableNotificationContent()
            content.title = "Snooze"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "alarmCategory"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
            let request = UNNotificationRequest(identifier: "Snooze", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        let uuid = response.notification.request.identifier
        _ = AlarmVC.shared.getAlarm(from: uuid)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        completionHandler()
    }
}
