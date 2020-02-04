//
//  InspirationViewController.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/19/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import SideMenu

class InspirationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleImage()
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") as! UISideMenuNavigationController
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        self.present(menu, animated: true)
    }
    @IBAction func lifePressed(_ sender: Any) {
        if let lifeVC = storyboard?.instantiateViewController(withIdentifier: "LifeViewController") {
            navigationController?.present(lifeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func fashionPressed(_ sender: Any) {
        
    }
    
    @IBAction func videosPressed(_ sender: Any) {
        if let videosVC = storyboard?.instantiateViewController(withIdentifier: "VideosViewController") {
            navigationController?.present(videosVC, animated: true, completion: nil)
        }
    }
    
}
