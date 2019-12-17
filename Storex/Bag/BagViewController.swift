//
//  SecondViewController.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class BagViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setNavigationTitleImage()
        
        initView()
        initVM()
    }
    
    func setNavigationTitleImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "nav-logo")!
        self.navigationItem.titleView = imageView
    }
    
    func initView() {
        
        menuButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let menu = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") as! UISideMenuNavigationController
            menu.setNavigationBarHidden(true, animated: false)
            SideMenuManager.default.menuPresentMode = .viewSlideInOut
            SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
            self.present(menu, animated: true)
        })
        .disposed(by: disposeBag)
        
    }

    func initVM() {
        
    }

}

