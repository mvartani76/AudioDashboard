//
//  ViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 8/3/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AADraggableViewDelegate, AppDownloadViewControllerDelegate {
    
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
        
        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        dashboardViewMatrix.enumerated().forEach { (index, dashboardView) in
        
            globalpoint = dashboardView.dView.superview?.convert(dashboardView.dView.frame.origin, to: nil) as! CGPoint

            dashboardView.dView.bounds.origin.x = dashboardView.dView.bounds.origin.x + globalpoint.x
            dashboardView.dView.bounds.origin.y = dashboardView.dView.bounds.origin.y + globalpoint.y

            if (dashboardView.dView.bounds.contains(sender.center)) && (dashboardViewsNumApps[index] > 0) {
                dashboardViewsNumApps[index] -= 1
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

    func draggingDidEnd(_ sender: UIView) {
        sender.layer.zPosition = 0
        sender.layer.shadowOffset = CGSize.zero
        sender.layer.shadowOpacity = 0.0
        sender.layer.shadowRadius = 0

        var globalpoint: CGPoint = CGPoint(x: 0,y: 0)

        dashboardViewMatrix.enumerated().forEach { (index, dashboardView) in
 
            globalpoint = dashboardView.dView.superview?.convert(dashboardView.dView.frame.origin, to: nil) as! CGPoint

            dashboardView.dView.bounds.origin.x = dashboardView.dView.bounds.origin.x + globalpoint.x
            dashboardView.dView.bounds.origin.y = dashboardView.dView.bounds.origin.y + globalpoint.y

            if (dashboardView.dView.bounds.contains(sender.center)) {
                dashboardView.dView.backgroundColor = UIColor.red
                sender.center.x = dashboardView.dView.bounds.origin.x + (dashboardView.dView.bounds.width / 2)
                sender.center.y = dashboardView.dView.bounds.origin.y + (dashboardView.dView.bounds.height / 2)
                // Increment the num apps in view for keeping track of dashboardview formatting
                dashboardViewsNumApps[index] += 1
            } else {
                // Only set the background color back to the original if there are currently no
                // apps in the dashboard view
                if (dashboardViewsNumApps[index] == 0) {
                    dashboardView.dView.backgroundColor = dashboardViewsBGColors[index]
                }
            }
            dashboardView.dView.bounds.origin = CGPoint(x:0,y:0)
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
                if identifier == "ShowModalView" {
                    if let viewController = segue.destination as? AppDownloadViewController {
                        viewController.delegate = self
                        //viewController.modalPresentationStyle = .fullScreen
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
        SystemConfig.shared.appMatrix.append((1, "Waves", "Music", 1, "waves-logo.jpg"))
        SystemConfig.shared.appMatrix.append((2, "Sony", "Music", 1, "sony-logo.png"))
        SystemConfig.shared.appMatrix.append((3, "dts", "Music", 1, "dts-logo.png"))
        SystemConfig.shared.appMatrix.append((4, "Petralex", "Hearing", 3, "petralex-logo.png"))
        SystemConfig.shared.appMatrix.append((5, "Alango", "Hearing", 3, "alango-logo.png"))
        SystemConfig.shared.appMatrix.append((6, "Eargo", "Hearing", 3, "eargo-logo.png"))
        SystemConfig.shared.appMatrix.append((7, "Dolby", "Phone", 2, "dolby-logo.png"))
        SystemConfig.shared.appMatrix.append((8, "Yamaha", "Phone", 2, "yamaha-logo.png"))
        SystemConfig.shared.appMatrix.append((9, "Dirac", "Phone", 2, "dirac-logo.png"))
    }

}
