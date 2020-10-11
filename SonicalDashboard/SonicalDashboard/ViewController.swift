//
//  ViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 8/3/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AADraggableViewDelegate, AppDownloadViewControllerDelegate, AppSettingsViewControllerDelegate {
    
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
    
    var dashboardViewMatrix: [(dView: UIView, dashboardType: String, isInput: Bool)] {
        return [(appSystemView, "System", true), (appMusicView, "Music", true), (appPhoneView, "Phone", true), (appHearingView, "Hearing", true), (appOtherView, "Other", true), (systemMusicView, "Music", false), (systemPhoneView, "Phone", false), (systemHearingView, "Hearing", false), (systemOtherView, "Other", false)]
    }
    var dashboardViewsBGColors: [UIColor] = []
    var dashboardViewsNumApps: [Int] = []
    var dashboardType: String = "System"
    var startingPoint: CGPoint = CGPoint(x: 0,y: 0)
    
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
    func draggingDidBegan(_ sender: AADraggableView) {
        sender.layer.zPosition = 100
        sender.layer.shadowOffset = CGSize(width: 0, height: 20)
        sender.layer.shadowOpacity = 0.3
        sender.layer.shadowRadius = 6

        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        dashboardViewMatrix.enumerated().forEach { (index, dashboardView) in
        
            globalpoint = dashboardView.dView.superview?.convert(dashboardView.dView.frame.origin, to: nil) as! CGPoint

            dashboardView.dView.bounds.origin.x = dashboardView.dView.bounds.origin.x + globalpoint.x
            dashboardView.dView.bounds.origin.y = dashboardView.dView.bounds.origin.y + globalpoint.y
            if (dashboardView.dView.bounds.contains(sender.center)) { //&& (dashboardViewsNumApps[index] > 0) {
                //dashboardViewsNumApps[index] -= 1
                if dashboardView.isInput {
                    dashboardType = dashboardView.dashboardType
                    print(dashboardView.dashboardType)
                }
                // save the starting point for the app to use when dragging the app to views it cannot go to
                // the behavior will be for the app to return to the startingPoint
                startingPoint.x = dashboardView.dView.bounds.origin.x + (dashboardView.dView.bounds.width / 2)
                startingPoint.y = dashboardView.dView.bounds.origin.y + (dashboardView.dView.bounds.height / 2)
            }
            dashboardView.dView.bounds.origin = CGPoint(x:0,y:0)
        }
    }

    func draggingDidChanged(_ sender: UIView) {
        //if (testView.frame.contains(sender.center)) {
          //  sender.center = testView.center
            //testView.backgroundColor = UIColor.red
        //}
    }

    func draggingDidEnd(_ sender: AADraggableView) {
        sender.layer.zPosition = 0
        sender.layer.shadowOffset = CGSize.zero
        sender.layer.shadowOpacity = 0.0
        sender.layer.shadowRadius = 0

        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)
        var entered: Bool = false
        dashboardViewMatrix.enumerated().forEach { (index, dashboardView) in
 
            globalpoint = dashboardView.dView.superview?.convert(dashboardView.dView.frame.origin, to: nil) as! CGPoint

            dashboardView.dView.bounds.origin.x = dashboardView.dView.bounds.origin.x + globalpoint.x
            dashboardView.dView.bounds.origin.y = dashboardView.dView.bounds.origin.y + globalpoint.y

            if ((dashboardView.dView.bounds.contains(sender.center)) && (!dashboardView.isInput) && (sender.appType == dashboardView.dashboardType)) {

                dashboardView.dView.backgroundColor = UIColor.red
                sender.center.x = dashboardView.dView.bounds.origin.x + (dashboardView.dView.bounds.width / 2)
                sender.center.y = dashboardView.dView.bounds.origin.y + (dashboardView.dView.bounds.height / 2)
                // Increment the num apps in view for keeping track of dashboardview formatting
                dashboardViewsNumApps[index] += 1
                entered = true
            } else {
                // Only set the background color back to the original if there are currently no
                // apps in the dashboard view
                if (dashboardViewsNumApps[index] == 0) {
                    dashboardView.dView.backgroundColor = dashboardViewsBGColors[index]
                }
            }
            dashboardView.dView.bounds.origin = CGPoint(x:0,y:0)
        }
        // after looping through all dashboard views, check to see if it entered any
        // if not, set the center back to the starting point
        if (!entered) {
            sender.center = startingPoint
        }
    }

    func doubleTap(_ sender: AADraggableView) {
        print("Detected double tap")
        // Blur the background when the modal is presented to the viewer
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.overlayBlurredBackgroundView()
        performSegue(withIdentifier: "ShowAppSettings", sender: nil)
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
        dashboardViewsBGColors.append(contentsOf: [UIColor](repeating: UIColor.systemFill, count:dashboardViewMatrix.count ))
        dashboardViewsNumApps.append(contentsOf: [Int](repeating: 0, count:dashboardViewMatrix.count ))

        for i in 0..<dashboardViewMatrix.count {
            dashboardViewsBGColors[i] = dashboardViewMatrix[i].dView.backgroundColor ?? UIColor.systemFill
            dashboardViewsNumApps[i] = 0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.postModalAddApp), name: NSNotification.Name(rawValue: "DismissAppDownloadModal"), object: nil)

        initializeAppMatrix()

    }

    override func viewWillAppear(_ animated: Bool) {
        // Set options
    }
    
    @IBAction func addApp(_ sender: Any) {
        
        // Blur the background when the modal is presented to the viewer
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.overlayBlurredBackgroundView()
    }
    
    @objc func postModalAddApp() {
        print("postmodaladdapp")
        print(SystemConfig.shared.selectedApp)
        SystemConfig.shared.myApps.append(AADraggableView(frame: CGRect(x:0, y:0, width: 50, height: 50)))
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].backgroundColor=UIColor.lightGray
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].layer.borderColor = UIColor.red.cgColor

        SystemConfig.shared.myApps[SystemConfig.shared.numApps].layer.cornerRadius = 10
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].clipsToBounds = true

        self.view.addSubview(SystemConfig.shared.myApps[SystemConfig.shared.numApps])
        print("numApps = \(SystemConfig.shared.numApps)")
        print("selectedApp = \(SystemConfig.shared.selectedApp)")
        print("size = \(SystemConfig.shared.appMatrix.count)")
        // Set the appType for the draggableView. This will be used for determing where the view
        // can be dragged to
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].appType = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].appType

        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        //globalpoint = addAppButton.superview?.convert(addAppButton.frame.origin, to: nil) as! CGPoint
        let viewSelect = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].appTypeId
        print("ViewSelect = \(viewSelect)")
        let appSelect = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].id
        globalpoint = dashboardViewMatrix[viewSelect].dView.superview?.convert(dashboardViewMatrix[viewSelect].dView.frame.origin, to: nil) as! CGPoint
        
        // Center the app view below the add app button
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].center.x = globalpoint.x + dashboardViewMatrix[viewSelect].dView.frame.width / 2 // addAppButton.frame.width / 2
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].center.y = globalpoint.y + dashboardViewMatrix[viewSelect].dView.frame.height / 2

        let imageName = SystemConfig.shared.appMatrix[appSelect-1].fileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        //let label = UILabel(frame: CGRect(x:0,y: 0, width:150, height:30))
        //label.textAlignment = .center
        //label.text = "App " + String(SystemConfig.shared.numApps)
        //SystemConfig.shared.myApps[SystemConfig.shared.numApps].addSubview(label)

        SystemConfig.shared.myApps[SystemConfig.shared.numApps].addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: SystemConfig.shared.myApps[SystemConfig.shared.numApps].centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: SystemConfig.shared.myApps[SystemConfig.shared.numApps].centerYAnchor).isActive = true

        // Configure Draggable View
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].delegate = self // AADraggableViewDelegate
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].respectedView = respectedView// reference view
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].reposition = .sticky// Reposition option
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].repositionIfNeeded() // Auto correct reposition
        respectedView.bringSubviewToFront(SystemConfig.shared.myApps[SystemConfig.shared.numApps])
        SystemConfig.shared.myApps[SystemConfig.shared.numApps].layer.zPosition = 1000
        
        // Increment the # of apps
        SystemConfig.shared.numApps += 1

    }

    func overlayBlurredBackgroundView() {

        let blurredBackgroundView = UIVisualEffectView()

        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .systemUltraThinMaterial)

        view.addSubview(blurredBackgroundView)
    }

    func removeBlurredBackgroundView() {

        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            print(identifier)
            if identifier == "ShowModalView" {
                if let viewController = segue.destination as? AppDownloadViewController {
                    viewController.delegate = self
                    self.modalPresentationStyle =  UIModalPresentationStyle(rawValue: 0)!
                }
            } else if identifier == "ShowAppSettings" {
                if let viewController = segue.destination as? AppSettingsViewController {
                    viewController.delegate = self
                    self.modalPresentationStyle =  UIModalPresentationStyle(rawValue: 0)!
                }
            }
        }
    }
    
    @IBAction func factoryReset(_ sender: Any) {
        // Remove all the app icons
        SystemConfig.shared.myApps.enumerated().forEach { (index, myApp) in
            myApp.removeFromSuperview()
        }
        SystemConfig.shared.myApps = []
        SystemConfig.shared.numApps = 0
        // Reset all the dashboard views back to original state
        dashboardViewMatrix.enumerated().forEach { (index, dashboardView) in
            dashboardViewsNumApps[index] = 0
            dashboardView.dView.backgroundColor = dashboardViewsBGColors[index]
        }
    }
    
    func initializeAppMatrix() {
        SystemConfig.shared.appMatrix.append((1, "Waves", "Waves spatial enhancer software","Music", 1, "waves-logo.jpg", 1, [ParamType(paramName: "Boost", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0), ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[0].numParams = SystemConfig.shared.appMatrix[0].params.count
        SystemConfig.shared.appMatrix.append((2, "Sony", "Sony music expander suite", "Music", 1, "sony-logo.png", 3, [ParamType(paramName: "Threshold", paramType: 1, paramMin: 0.0, paramMax: 1.0, paramGUIType: 1), ParamType(paramName: "Aggressiveness", paramType: 1, paramMin: 0.0, paramMax: 1.0, paramGUIType: 1), ParamType(paramName: "Gain", paramType: 1, paramMin: 0.0, paramMax: 1.0, paramGUIType: 1),
            ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[1].numParams = SystemConfig.shared.appMatrix[1].params.count
        SystemConfig.shared.appMatrix.append((3, "dts", "DTS audio enhancement", "Music", 1, "dts-logo.png", 1, [ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[2].numParams = SystemConfig.shared.appMatrix[2].params.count
        SystemConfig.shared.appMatrix.append((4, "Petralex", "Petralex assisted hearing device algorithms",  "Hearing", 3, "petralex-logo.png", 1, [ParamType(paramName: "Gain", paramType: 1, paramMin: 0.0, paramMax: 1.0, paramGUIType: 1), ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[3].numParams = SystemConfig.shared.appMatrix[3].params.count
        SystemConfig.shared.appMatrix.append((5, "Alango", "Alango assisted hearing device algorithms", "Hearing", 3, "alango-logo.png", 1, [ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[4].numParams = SystemConfig.shared.appMatrix[4].params.count
        SystemConfig.shared.appMatrix.append((6, "Eargo", "Eargo assisted hearing device algorithms",  "Hearing", 3, "eargo-logo.png", 1, [ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[5].numParams = SystemConfig.shared.appMatrix[5].params.count
        SystemConfig.shared.appMatrix.append((7, "Dolby", "Dolby phone audio optimization suite", "Phone", 2, "dolby-logo.png", 1, [ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[6].numParams = SystemConfig.shared.appMatrix[6].params.count
        SystemConfig.shared.appMatrix.append((8, "Yamaha", "Yamaha phone audio optimization suite", "Phone", 2, "yamaha-logo.png", 1, [ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[7].numParams = SystemConfig.shared.appMatrix[7].params.count
        SystemConfig.shared.appMatrix.append((9, "Dirac", "Dirac phone audio optimization suite", "Phone", 2, "dirac-logo.png", 1, [ParamType(paramName: "Gain", paramType: 1, paramMin: 0.0, paramMax: 1.0, paramGUIType: 1), ParamType(paramName: "Bypass", paramType: 0, paramMin: 0.0, paramMax: 0.0, paramGUIType: 0)]))
        SystemConfig.shared.appMatrix[8].numParams = SystemConfig.shared.appMatrix[8].params.count
    }

}
