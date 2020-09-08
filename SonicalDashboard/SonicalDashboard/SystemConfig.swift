//
//  SystemConfig.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 9/6/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import Foundation

class SystemConfig {
    static let shared = SystemConfig()
    
    var numApps: Int
    var selectedApp: Int
    
    private init() {
        numApps = 0
        selectedApp = 1
    }
}
