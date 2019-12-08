//
//  NotificationBannerManager.swift
//  Storex
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class NotificationBannerManager {
    
    class func show(title: String, message: String) {
        let banner = NotificationBanner(title: title, subtitle: message, style: .warning)
        banner.show()
    }
}
