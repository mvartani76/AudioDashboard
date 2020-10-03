//
//  SystemConfig.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 9/6/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import Foundation

// Struct that defines the parameters
// 1. Name of Parameter
// 2. Type of Parameter: (0) Bool, (1) Int, (2) Double, (3) String, ...
// 3/4. paramMin / paramMax: (if applicable)
// 5. Type of GUI for parameter: (0) Button, (1) Slider
struct ParamType {
    var paramName: String
    var paramType: Int
    var paramMin: Double
    var paramMax: Double
    var paramGUIType: Int
}

class SystemConfig {
    static let shared = SystemConfig()
    
    var numApps: Int
    var tempSelectedApp: Int
    var selectedApp: Int
    var myApps: [AADraggableView] = []
    
    var appMatrix: [(id: Int, name: String, appType: String, appTypeId: Int, fileName: String, numParams: Int, params: [ParamType])] = []
    
    private init() {
        numApps = 0
        tempSelectedApp = 1
        selectedApp = 1
    }
}
