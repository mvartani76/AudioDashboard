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
    var tempSelectedApp: Int
    var selectedApp: Int
    var myApps: [AADraggableView] = []
    
    var appMatrix: [(id: Int, name: String, appType: String, appTypeId: Int)] = []
    
    private init() {
        numApps = 0
        tempSelectedApp = 1
        selectedApp = 1
    }
}
