//
//  OnBoardingVC.swift
//  Storex
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnBoardingVC: UIViewController {
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bullet1: UIImageView!
    @IBOutlet weak var bullet2: UIImageView!
    @IBOutlet weak var bullet3: UIImageView!
    @IBOutlet weak var selectedCenterX: NSLayoutConstraint!
    
    var bullets: [UIImageView]?
    var currentIndex = 0
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bullets = [bullet1, bullet2, bullet3]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOnBoardingPageVC" {
            let onBoardingPageVC = segue.destination as! OnBoardingPageVC
            
            self.continueButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    if self?.currentIndex == 2 {
                        print("Navigate to sign in")
                        if let onBoardingFinishVC = self?.storyboard?.instantiateViewController(withIdentifier: "OnBoardingFinish") {
                            self?.navigationController?.pushViewController(onBoardingFinishVC, animated: true)
                        }
                    } else { onBoardingPageVC.goToNextPage() }
                })
                .disposed(by: self.disposeBag)
            
            onBoardingPageVC.currentScreenIndex
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] index in
                    print("Current Index: \(index)")
                    self?.currentIndex = index
                    if let self = self {
                        UIView.animate(withDuration: 0.2) {
                            self.selectedCenterX.constant = (self.bullets?[index].frame.origin.x)!
                            self.view.layoutIfNeeded()
                        }
                    }
                })
                .disposed(by: self.disposeBag)
            
        }
    }
    
    
}
