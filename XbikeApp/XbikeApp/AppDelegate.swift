//
//  AppDelegate.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 23/08/22.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyBd7TobSF4fQGVxT3kk1panh_kKr8ZxrTI")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "hasOnBoarding") {
            window?.rootViewController = UIStoryboard(name: "Tabbar", bundle: nil).instantiateInitialViewController()
        } else {
            window?.rootViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            
        }
        
        window?.makeKeyAndVisible()
        
        self.changeColorStatus()
        
        return true
    }
    
    func changeColorStatus(){
        if #available(iOS 13, *) {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.init(hex: "#FF8E25FF") ?? .orange
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             // ADD THE STATUS BAR AND SET A CUSTOM COLOR
             let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
             if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = #colorLiteral(red: 1, green: 0.5568627451, blue: 0.1450980392, alpha: 1)
             }
             UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func loadTabBar(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "hasOnBoarding")
        window?.rootViewController = UIStoryboard(name: "Tabbar", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        changeColorStatus()
    }


}

