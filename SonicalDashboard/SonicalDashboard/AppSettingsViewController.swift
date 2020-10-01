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
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewwillappear")
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

        //imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        imageView.center = CGPoint(x: logoView.frame.midX,
        y: logoView.frame.midY)
    }
}
