//
//  Switcher.swift
//  Storex
//
//  Created by admin on 12/9/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class Switcher {
    
    static func updateRootVC() {
        
        let isLoggedin = UserDefaults.standard.bool(forKey: "isLoggedin")
        var rootVC : UIViewController?
        
        print("isLoggedin:", isLoggedin)
        
        if isLoggedin == true {
            
            // check for token expire :
            let loginDate = UserDefaults.standard.object(forKey: "loginDate") as! Date
            if isTokenPass24(loginDate: loginDate) {
                print("token passed 24h - logging out ...")
                logOut()
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingNavigation") as! OnBoardingNavigation
            } else {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
            }
            
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingNavigation") as! OnBoardingNavigation
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
    static func loggedWith(token: String) {
        UserDefaults.standard.set(true, forKey: "isLoggedin")
        UserDefaults.standard.set(token, forKey: "token")
        let loginTime = Date()
        UserDefaults.standard.set(loginTime, forKey: "loginDate")
    }
    
    static func logOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedin")
        UserDefaults.standard.set(nil, forKey: "token")
        UserDefaults.standard.set(nil, forKey: "loginDate")
    }
    
    private static func isTokenPass24(loginDate: Date) -> Bool {
        let currentDate = Date()
//        print("current: \(currentDate) - loggedin: \(loginDate)")
        let loggedSince = currentDate.timeIntervalSince(loginDate)
        let hours = Double(round(100 * (loggedSince / 3600.00))/100)
//        print("logged since: \(hours) hours")
        return hours >= 24.00
    }
    
}
