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

    var paramViews : [UIView] = []
    var buttonItems : [UIButton] = []
    var sliderItems : [UISlider] = []
    var guiIndices : [Int] = []
    var paramTitleLabels : [UILabel] = []
    var sliderValueLabels : [UILabel] = []
    var sliderStackViews : [UIStackView] = []
    var sliderTextLabels : [UILabel] = []

    // Button Titles for enabled/disabled states
    var buttonTitlePos = ""
    var buttonTitleNeg = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        // Initialize button gradient
        let saveTopGradientColor = ConstantsEnum.AppSettings.Colors.Buttons.saveTopGradientColor
        let saveBottomGradientColor = ConstantsEnum.AppSettings.Colors.Buttons.saveBottomGradientColor
        let canTopGradientColor = ConstantsEnum.AppSettings.Colors.Buttons.canTopGradientColor
        let canBottomGradientColor = ConstantsEnum.AppSettings.Colors.Buttons.canBottomGradientColor

        let saveGradientLayer = CAGradientLayer()
        let canGradientLayer = CAGradientLayer()

        saveGradientLayer.frame = saveParamsButton.bounds
        saveGradientLayer.colors = [saveTopGradientColor.cgColor, saveBottomGradientColor.cgColor]

        //Vertical
        saveGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        saveGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        saveGradientLayer.locations = [0.0, 1.0]

        saveParamsButton.layer.insertSublayer(saveGradientLayer, at: 0)
        saveParamsButton.layer.cornerRadius = ConstantsEnum.AppSettings.CornerRadius.Buttons.saveParamsButtonCornerRadius
        saveParamsButton.clipsToBounds = true
        saveParamsButton.alpha = 0.5

        canGradientLayer.frame = cancelParamsButton.bounds

        canGradientLayer.colors = [canTopGradientColor.cgColor, canBottomGradientColor.cgColor]

        //Vertical
        canGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        canGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        cancelParamsButton.layer.insertSublayer(canGradientLayer, at: 0)
        cancelParamsButton.layer.cornerRadius = ConstantsEnum.AppSettings.CornerRadius.Buttons.cancelParamsButtonCornerRadius
        cancelParamsButton.clipsToBounds = true

        let appSelect = SystemConfig.shared.appMatrix[SystemConfig.shared.selectedApp-1].id
        let imageName = SystemConfig.shared.appMatrix[appSelect-1].fileName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        let maxDim = 0.8 * min(logoView.frame.width, logoView.frame.height)
        imageView.frame = CGRect(x: 0, y: 0, width: maxDim, height: maxDim)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = ConstantsEnum.AppSettings.CornerRadius.ImageView.appSettingsVCImageViewCornerRadius 
        imageView.clipsToBounds = true
        logoView.addSubview(imageView)
        descriptionLabel.text = SystemConfig.shared.appMatrix[appSelect-1].description
        descriptionLabel.font = ConstantsEnum.AppSettings.Fonts.descriptionLabelFont

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

        // Initialize numParams # of UIButtons/UISliders/labels
        for _ in 1...numParams {
            buttonItems.append(UIButton())
            sliderItems.append(UISlider())
            paramTitleLabels.append(UILabel())
            sliderValueLabels.append(UILabel())
            sliderStackViews.append(UIStackView())
            sliderTextLabels.append(UILabel())
        }

        paramViews.append(UIView())
        paramViews[0].backgroundColor = UIColor.red
        paramsGUIStackView.addArrangedSubview(paramViews[0])

        paramViews.append(UIView())
        paramViews[1].backgroundColor = UIColor.red
        paramsGUIStackView.addArrangedSubview(paramViews[1])
        
        // Only loop through other parameter views if there is more than 1 parameter
        if (numParams > 1) {
            for i in 1...(numParams-1) {
                paramViews.append(UIView())
                paramViews.append(UIView())
                if i == 1 {
                    paramViews[2*i].backgroundColor = UIColor.yellow
                    paramViews[2*i+1].backgroundColor = UIColor.yellow
                } else {
                    paramViews[2*i].backgroundColor = UIColor.green
                    paramViews[2*i+1].backgroundColor = UIColor.green
                }
                paramsGUIStackView.addArrangedSubview(paramViews[2*i])
                paramsGUIStackView.addArrangedSubview(paramViews[2*i+1])
            }

            paramsView.addSubview(paramsGUIStackView)
            for i in 0...(numParams-1) {
                paramViews[2*i].widthAnchor.constraint(equalTo: paramsGUIStackView.widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsTitleWidthMultiplier).isActive = true
                paramViews[2*i+1].widthAnchor.constraint(equalTo: paramsGUIStackView.widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsGUIWidthMultiplier).isActive = true
                if (i > 0) {
                    paramViews[2*i].heightAnchor.constraint(equalTo: paramViews[0].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsTitleHeightMultiplier).isActive = true
                    paramViews[2*i+1].heightAnchor.constraint(equalTo: paramViews[0].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsGUIHeightMultiplier).isActive = true
                } else {
                    paramViews[2*i+1].heightAnchor.constraint(equalTo: paramViews[0].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsGUIHeightMultiplier).isActive = true
                }
            }
        } else {
            paramViews[1].heightAnchor.constraint(equalTo: paramViews[0].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramsGUIHeightMultiplier).isActive = true
        }

        for i in 0...(numParams-1) {
            // Check what type of GUI parameter will be used
            switch SystemConfig.shared.appMatrix[appSelect-1].params[i].paramGUIType {
                case 0:
                    if (SystemConfig.shared.appMatrix[appSelect-1].params[i].paramName == "Bypass") {
                        buttonTitlePos = "Enabled"
                        buttonTitleNeg = "Disabled"
                    }
                    buttonItems[i].setTitle(buttonTitlePos, for: .normal)
                    buttonItems[i].titleLabel?.font = ConstantsEnum.AppSettings.Fonts.paramButtonTitleLabelFont
                    buttonItems[i].backgroundColor = UIColor(red: 64/255, green: 62/255, blue: 61/255, alpha: 1.0)
                    buttonItems[i].setTitleColor(.white, for: .normal)
                    buttonItems[i].translatesAutoresizingMaskIntoConstraints = false
                    paramTitleLabels[i].text = SystemConfig.shared.appMatrix[appSelect-1].params[i].paramName
                    paramTitleLabels[i].textAlignment = .center
                    paramTitleLabels[i].font = ConstantsEnum.AppSettings.Fonts.paramTitleLabelFont
                    paramTitleLabels[i].translatesAutoresizingMaskIntoConstraints = false

                    buttonItems[i].tag = i
                    buttonItems[i].addTarget(self, action: #selector(self.buttonTouched), for: .touchUpInside)

                    paramViews[2*i].addSubview(paramTitleLabels[i])
                    paramViews[2*i+1].addSubview(buttonItems[i])
                    buttonItems[i].widthAnchor.constraint(equalTo: paramViews[2*i+1].widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.buttonItemWidthMultiplier).isActive = true
                    buttonItems[i].heightAnchor.constraint(equalTo: paramViews[2*i+1].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.buttonItemHeightMultiplier).isActive = true
                    paramTitleLabels[i].centerXAnchor.constraint(equalTo: paramViews[2*i].centerXAnchor).isActive = true
                    paramTitleLabels[i].centerYAnchor.constraint(equalTo: paramViews[2*i].centerYAnchor).isActive = true
                    buttonItems[i].centerXAnchor.constraint(equalTo: paramViews[2*i+1].centerXAnchor).isActive = true
                    buttonItems[i].centerYAnchor.constraint(equalTo: paramViews[2*i+1].centerYAnchor).isActive = true
                    buttonItems[i].layer.cornerRadius = ConstantsEnum.AppSettings.CornerRadius.Buttons.paramButtonItemCornerRadius
                        guiIndices.append(0)
                case 1:
                    sliderItems[i].maximumValue = Float(SystemConfig.shared.appMatrix[appSelect-1].params[i].paramMax)
                    sliderItems[i].minimumValue = Float(SystemConfig.shared.appMatrix[appSelect-1].params[i].paramMin)
                    sliderItems[i].isContinuous = true
                    sliderItems[i].tintColor = UIColor.black
                    sliderStackViews[i].translatesAutoresizingMaskIntoConstraints = false
                    paramTitleLabels[i].text = SystemConfig.shared.appMatrix[appSelect-1].params[i].paramName
                    paramTitleLabels[i].textAlignment = .center
                    paramTitleLabels[i].font = ConstantsEnum.AppSettings.Fonts.paramTitleLabelFont
                    paramTitleLabels[i].translatesAutoresizingMaskIntoConstraints = false
                    paramViews[2*i].addSubview(paramTitleLabels[i])
                    paramViews[2*i+1].addSubview(sliderStackViews[i])
                    paramTitleLabels[i].widthAnchor.constraint(equalTo: paramViews[2*i].widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.paramTitleLabelWidthMultiplier).isActive = true
                    sliderStackViews[i].widthAnchor.constraint(equalTo: paramViews[2*i+1].widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.sliderStackViewWidthMultiplier).isActive = true
                    sliderStackViews[i].heightAnchor.constraint(equalTo: paramViews[2*i+1].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.sliderStackViewHeightMultiplier).isActive = true
                    paramTitleLabels[i].centerXAnchor.constraint(equalTo: paramViews[2*i].centerXAnchor).isActive = true
                    paramTitleLabels[i].centerYAnchor.constraint(equalTo: paramViews[2*i].centerYAnchor).isActive = true
                    sliderStackViews[i].centerXAnchor.constraint(equalTo: paramViews[2*i+1].centerXAnchor).isActive = true
                    sliderStackViews[i].centerYAnchor.constraint(equalTo: paramViews[2*i+1].centerYAnchor).isActive = true

                    sliderTextLabels[i].textAlignment = .center
                    sliderTextLabels[i].font = ConstantsEnum.AppSettings.Fonts.sliderTextLabelFont
                    sliderItems[i].tag = i
                    sliderTextLabels[i].text = String(format: "%.2f", sliderItems[i].value)
                    sliderItems[i].addTarget(self, action: #selector(self.sliderValueDidChange),for: .valueChanged)

                    sliderStackViews[i].addArrangedSubview(sliderItems[i])
                    sliderStackViews[i].addArrangedSubview(sliderTextLabels[i])

                    sliderItems[i].heightAnchor.constraint(equalTo: sliderStackViews[i].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.sliderItemHeightMultiplier).isActive = true
                    sliderTextLabels[i].heightAnchor.constraint(equalTo: sliderStackViews[i].heightAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.sliderTextLabelHeightMultiplier).isActive = true
                    sliderItems[i].widthAnchor.constraint(equalTo: sliderTextLabels[i].widthAnchor, multiplier: ConstantsEnum.AppSettings.Constraints.sliderItemWidthMultiplier).isActive = true

                    guiIndices.append(1)
                default:
                    print("error")
            }

        }
    }

    @objc func sliderValueDidChange(sender: UISlider!)
    {
        sliderTextLabels[sender.tag].text = String(format: "%.2f", sender.value)

    }

    @objc func buttonTouched(sender: UIButton!) {
        // Toggle the button title and color based on state
        if sender.titleLabel?.text == buttonTitlePos {
            sender.setTitle(buttonTitleNeg, for: .normal)
            sender.backgroundColor = ConstantsEnum.AppSettings.Colors.Buttons.unselectedAudioAppColor
        } else {
            sender.setTitle(buttonTitlePos, for: .normal)
            sender.backgroundColor = ConstantsEnum.AppSettings.Colors.Buttons.selectedAudioAppColor
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
