//
//  SideMenuViewController.swift
//  Storex
//
//  Created by admin on 12/16/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuViewController: UIViewController {
    
    // MARK:- Outlets :
    // MARK: Views as Buttons :
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var bagView: UIView!
    @IBOutlet weak var inspirationView: UIView!
    @IBOutlet weak var storesView: UIView!
    
    // MARK: Buttons :
    @IBOutlet weak var myAccountButton: UIButton!
    @IBOutlet weak var customerSupportButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: Follow Us :
    @IBOutlet weak var followOnFacebookButton: UIButton!
    @IBOutlet weak var followOnTwitterButton: UIButton!
    @IBOutlet weak var followOnPintrestButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView() {
        
        // MARK:- tap on shop :
        
        let tapOnShop = UITapGestureRecognizer()
        shopView.addGestureRecognizer(tapOnShop)
        
        tapOnShop.rx.event.bind { [weak self] recognizer in
            guard let self = self else { return }
            self.switchTabBarTo(0)
        }.disposed(by: disposeBag)
        
        // MARK:- tap on bag :
        
        let tapOnBag = UITapGestureRecognizer()
        bagView.addGestureRecognizer(tapOnBag)
        
        tapOnBag.rx.event.bind { [weak self] recognizer in
            guard let self = self else { return }
            self.switchTabBarTo(2)
        }.disposed(by: disposeBag)
        
        // MARK:- tap on inspiration :
        
        let tapOnInspiration = UITapGestureRecognizer()
        inspirationView.addGestureRecognizer(tapOnInspiration)
        
        tapOnInspiration.rx.event.bind { [weak self] recognizer in
            guard let self = self else { return }
            self.switchTabBarTo(1)
        }.disposed(by: disposeBag)
        
        // MARK:- tap on stores :
        
        let tapOnStores = UITapGestureRecognizer()
        storesView.addGestureRecognizer(tapOnStores)
        
        tapOnStores.rx.event.bind { [weak self] recognizer in
            guard let self = self else { return }
            self.switchTabBarTo(3)
        }.disposed(by: disposeBag)
        
        // MARK:- buttons handling :
        
        logoutButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                Switcher.logOut()
                Switcher.updateRootVC()
            })
        .disposed(by: disposeBag)
    }
    
    
    private func switchTabBarTo(_ index: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.dismiss(animated: true)
        appDelegate.mainTabBar?.selectedIndex = index
    }
}
