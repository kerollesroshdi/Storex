//
//  MainTabBarVC.swift
//  Storex
//
//  Created by admin on 12/9/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // setting tabBar reference:
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainTabBar = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
