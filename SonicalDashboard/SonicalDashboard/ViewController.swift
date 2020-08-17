//
//  ViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 8/3/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AADraggableViewDelegate {
    
    @IBOutlet var respectedView: UIView!
    @IBOutlet var systemPickerView: UIPickerView!
    
    @IBOutlet var factoryResetButton: UIButton!
    @IBOutlet var addAppButton: UIButton!
    
    @IBOutlet var appSystemView: UIView!
    @IBOutlet var appMusicView: UIView!
    @IBOutlet var appPhoneView: UIView!
    @IBOutlet var appHearingView: UIView!
    @IBOutlet var appOtherView: UIView!
    @IBOutlet var systemMusicView: UIView!
    @IBOutlet var systemPhoneView: UIView!
    @IBOutlet var systemHearingView: UIView!
    @IBOutlet var systemOtherView: UIView!
    
    var dashboardViews: [UIView] {
        return [appSystemView, appMusicView, appPhoneView, appHearingView, appOtherView, systemMusicView, systemPhoneView, systemHearingView, systemOtherView]
    }
    var dashboardViewsBGColors: [UIColor] = []
    
    var myApps: [AADraggableView] = []
    var numApps = 0
    
    let systemConfigurations = ["Individual", "Work", "Home", "Fitness"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return systemConfigurations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return systemConfigurations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.regular)
        label.text =  systemConfigurations[row]
        label.textAlignment = .center
        return label
    }
    
    // Add delegate methods and observe changes!
    func draggingDidBegan(_ sender: UIView) {
        sender.layer.zPosition = 100
        sender.layer.shadowOffset = CGSize(width: 0, height: 20)
        sender.layer.shadowOpacity = 0.3
        sender.layer.shadowRadius = 6
    }
    
    func draggingDidChanged(_ sender: UIView) {
        //if (testView.frame.contains(sender.center)) {
          //  sender.center = testView.center
            //testView.backgroundColor = UIColor.red
        //}
    }
    
    func draggingDidEnd(_ sender: UIView) {
        sender.layer.zPosition = 0
        sender.layer.shadowOffset = CGSize.zero
        sender.layer.shadowOpacity = 0.0
        sender.layer.shadowRadius = 0

        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        dashboardViews.enumerated().forEach { (index, dashboardView) in
 
            globalpoint = dashboardView.superview?.convert(dashboardView.frame.origin, to: nil) as! CGPoint

            dashboardView.bounds.origin.x = dashboardView.bounds.origin.x + globalpoint.x
            dashboardView.bounds.origin.y = dashboardView.bounds.origin.y + globalpoint.y
            
            if (dashboardView.bounds.contains(sender.center)) {
                dashboardView.backgroundColor = UIColor.red
                sender.center.x = dashboardView.bounds.origin.x + (dashboardView.bounds.width / 2)
                sender.center.y = dashboardView.bounds.origin.y + (dashboardView.bounds.height / 2)
            } else {
                dashboardView.backgroundColor = dashboardViewsBGColors[index]
            }
            dashboardView.bounds.origin = CGPoint(x:0,y:0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemPickerView.delegate = self
        systemPickerView.dataSource = self
        
        // Initialize button gradient
        let frbTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
        let frbBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)

        let frbGradientLayer = CAGradientLayer()
        let apbGradientLayer = CAGradientLayer()

        frbGradientLayer.frame = factoryResetButton.bounds
        frbGradientLayer.colors = [frbTopGradientColor.cgColor, frbBottomGradientColor.cgColor]

        //Vertical
        frbGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        frbGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        frbGradientLayer.locations = [0.0, 1.0]

        factoryResetButton.layer.insertSublayer(frbGradientLayer, at: 0)
        factoryResetButton.layer.cornerRadius = 10
        factoryResetButton.clipsToBounds = true
        
        apbGradientLayer.frame = addAppButton.bounds

        apbGradientLayer.colors = [frbTopGradientColor.cgColor, frbBottomGradientColor.cgColor]

        //Vertical
        apbGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        apbGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        addAppButton.layer.insertSublayer(apbGradientLayer, at: 0)
        addAppButton.layer.cornerRadius = 10
        addAppButton.clipsToBounds = true
        
        // Get the initial background colors for the views
        dashboardViewsBGColors.append(contentsOf: [UIColor](repeating: UIColor.systemFill, count:dashboardViews.count ))
        for i in 0..<dashboardViews.count {
            dashboardViewsBGColors[i] = dashboardViews[i].backgroundColor ?? UIColor.systemFill
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Set options

    }
    
    @IBAction func addApp(_ sender: Any) {
        myApps.append(AADraggableView(frame: CGRect(x:0, y:0, width: 150, height: 30)))
        myApps[numApps].backgroundColor=UIColor.lightGray
        myApps[numApps].layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(myApps[numApps])
        
        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        globalpoint = addAppButton.superview?.convert(addAppButton.frame.origin, to: nil) as! CGPoint
        
        // Center the app view below the add app button
        myApps[numApps].center.x = globalpoint.x + addAppButton.frame.width / 2
        myApps[numApps].center.y = globalpoint.y + addAppButton.frame.height + 20
        
        let label = UILabel(frame: CGRect(x:0,y: 0, width:150, height:30))
        label.textAlignment = .center
        label.text = "App " + String(numApps)
        myApps[numApps].addSubview(label)
        
        // Configure Draggable View
        myApps[numApps].delegate = self // AADraggableViewDelegate
        myApps[numApps].respectedView = respectedView// reference view
        myApps[numApps].reposition = .sticky// Reposition option
        myApps[numApps].repositionIfNeeded() // Auto correct reposition
        respectedView.bringSubviewToFront(myApps[numApps])
        myApps[numApps].layer.zPosition = 1000
        
        // Increment the # of apps
        numApps += 1
    }
    
}
