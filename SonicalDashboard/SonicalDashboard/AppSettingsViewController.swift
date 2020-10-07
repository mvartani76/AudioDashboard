//
//  AppSettingsViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 9/27/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit

protocol AppSettingsViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}

class AppSettingsViewController: UIViewController {

    @IBOutlet var appSettingsMainView: UIView!
    @IBOutlet var logoView: UIView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var paramsView: UIView!
    @IBOutlet var paramsGUIStackView: UIStackView!
    
    @IBOutlet var saveParamsButton: UIButton!
    @IBOutlet var cancelParamsButton: UIButton!

    weak var delegate: AppSettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        // Initialize button gradient
        let saveTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
        let saveBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
        let canTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
        let canBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)

        let saveGradientLayer = CAGradientLayer()
        let canGradientLayer = CAGradientLayer()

        saveGradientLayer.frame = saveParamsButton.bounds
        saveGradientLayer.colors = [saveTopGradientColor.cgColor, saveBottomGradientColor.cgColor]

        //Vertical
        saveGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        saveGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        saveGradientLayer.locations = [0.0, 1.0]

        saveParamsButton.layer.insertSublayer(saveGradientLayer, at: 0)
        saveParamsButton.layer.cornerRadius = 10
        saveParamsButton.clipsToBounds = true
        saveParamsButton.alpha = 0.5

        canGradientLayer.frame = cancelParamsButton.bounds

        canGradientLayer.colors = [canTopGradientColor.cgColor, canBottomGradientColor.cgColor]

        //Vertical
        canGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        canGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        cancelParamsButton.layer.insertSublayer(canGradientLayer, at: 0)
        cancelParamsButton.layer.cornerRadius = 10
        cancelParamsButton.clipsToBounds = true

        let appSelect = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].id
        let imageName = SystemConfig.shared.appMatrix[appSelect-1].fileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        let maxDim = 0.8 * min(logoView.frame.width, logoView.frame.height)
        imageView.frame = CGRect(x: 0, y: 0, width: maxDim, height: maxDim)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        logoView.addSubview(imageView)
        descriptionLabel.text = SystemConfig.shared.appMatrix[appSelect-1].description

        //imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        imageView.center = CGPoint(x: logoView.frame.midX,
        y: logoView.frame.midY)
        print(SystemConfig.shared.appMatrix[appSelect-1].params)
        loadAppParamsGUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewwillappear")
    }
    
    func loadAppParamsGUI() {
        
        let appSelect = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].id
        let numParams = SystemConfig.shared.appMatrix[appSelect-1].numParams

        var paramViews : [UIView] = []
        var buttonItems : [UIButton] = []
        var sliderItems : [UISlider] = []
        var guiIndices : [Int] = []
        
        // Initialize numParams # of UIButtons/UISliders
        for _ in 1...numParams {
            buttonItems.append(UIButton())
            sliderItems.append(UISlider())
        }
        
        paramViews.append(UIView())
        paramViews[0].backgroundColor = UIColor.red
        paramsGUIStackView.addArrangedSubview(paramViews[0])
        
        // Only loop through other parameter views if there is more than 1 parameter
        if (numParams > 1) {
            for i in 1...(numParams-1) {
                paramViews.append(UIView())
                if i == 1 {
                    paramViews[i].backgroundColor = UIColor.yellow
                } else {
                    paramViews[i].backgroundColor = UIColor.green
                }
                paramsGUIStackView.addArrangedSubview(paramViews[i])
            }

            paramsView.addSubview(paramsGUIStackView)
            for i in 0...(numParams-1) {
                paramViews[i].widthAnchor.constraint(equalTo: paramsGUIStackView.widthAnchor, multiplier: 1.0).isActive = true
                if (i > 0) {
                    paramViews[i].heightAnchor.constraint(equalTo: paramViews[0].heightAnchor, multiplier: 1.0).isActive = true
                }
            }
        }
        for i in 0...(numParams-1) {
            // Check what type of GUI parameter will be used
            switch SystemConfig.shared.appMatrix[appSelect-1].params[i].paramGUIType {
                case 0:
                    print(buttonItems)
                    print(paramViews)
                    //buttonItems.append(UIButton(type: .system))
                    buttonItems[i].setTitle("Hello", for: .normal)
                    buttonItems[i].backgroundColor = UIColor.black
                    buttonItems[i].setTitleColor(.white, for: .normal)
                    buttonItems[i].translatesAutoresizingMaskIntoConstraints = false
                    paramViews[i].addSubview(buttonItems[i])
                    buttonItems[i].widthAnchor.constraint(equalTo: paramViews[i].widthAnchor, multiplier: 0.8).isActive = true
                    buttonItems[i].heightAnchor.constraint(equalTo: paramViews[i].heightAnchor, multiplier: 0.8).isActive = true
                    buttonItems[i].centerXAnchor.constraint(equalTo: paramViews[i].centerXAnchor).isActive = true
                    buttonItems[i].centerYAnchor.constraint(equalTo: paramViews[i].centerYAnchor).isActive = true
                    buttonItems[i].layer.cornerRadius = 5
                        guiIndices.append(0)
                case 1:
                    print("set slider \(i)")
                    //sliderItems.append(UISlider())
                    sliderItems[i].isContinuous = true
                    sliderItems[i].tintColor = UIColor.black
                    sliderItems[i].translatesAutoresizingMaskIntoConstraints = false
                    paramViews[i].addSubview(sliderItems[i])
                    sliderItems[i].widthAnchor.constraint(equalTo: paramViews[i].widthAnchor, multiplier: 0.8).isActive = true
                    sliderItems[i].heightAnchor.constraint(equalTo: paramViews[i].heightAnchor, multiplier: 0.8).isActive = true
                    sliderItems[i].centerXAnchor.constraint(equalTo: paramViews[i].centerXAnchor).isActive = true
                    sliderItems[i].centerYAnchor.constraint(equalTo: paramViews[i].centerYAnchor).isActive = true
                    guiIndices.append(1)
                default:
                    print("error")
            }

        }
    }

    @IBAction func saveParams(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissAppDownloadModal"), object: nil)

        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    @IBAction func cancelParams(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    

}
