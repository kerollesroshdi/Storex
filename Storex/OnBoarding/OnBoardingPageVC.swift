//
//  OnBoardingPageVC.swift
//  Storex
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift

class OnBoardingPageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var onBoardingScreens: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let screen1 = storyboard.instantiateViewController(withIdentifier: "OnBoardingScreenVC") as! OnBoardingScreenVC
        screen1.index = 0
        let screen2 = storyboard.instantiateViewController(withIdentifier: "OnBoardingScreenVC") as! OnBoardingScreenVC
        screen2.index = 1
        let screen3 = storyboard.instantiateViewController(withIdentifier: "OnBoardingScreenVC") as! OnBoardingScreenVC
        screen3.index = 2
        
        return [screen1, screen2, screen3]
    }()
    
    
    let currentScreenIndex: PublishSubject<Int> = PublishSubject()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onBoardingScreens.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
//        currentScreenIndex.onNext(previousIndex)
        return onBoardingScreens[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onBoardingScreens.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < onBoardingScreens.count else { return nil }
//        currentScreenIndex.onNext(nextIndex)
        return onBoardingScreens[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first as? OnBoardingScreenVC {
                currentScreenIndex.onNext(currentViewController.index)
            } else {
                print("cannot cast currentViewController")
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
        if let firstScreen = onBoardingScreens.first {
            self.setViewControllers([firstScreen], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension OnBoardingPageVC {
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        currentScreenIndex.onNext((nextViewController as? OnBoardingScreenVC)?.index ?? 1)
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
}
