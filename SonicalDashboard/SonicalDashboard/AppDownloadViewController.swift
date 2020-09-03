//
//  AppDownloadViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 9/1/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit

protocol AppDownloadViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}

class AppDownloadViewController: UIViewController {

    weak var delegate: AppDownloadViewControllerDelegate?
    @IBOutlet var selectAudioAppButton: UIButton!
    @IBOutlet var cancelAudioAppButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize button gradient
        let selTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
        let selBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
        let canTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
        let canBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)

        let selGradientLayer = CAGradientLayer()
        let canGradientLayer = CAGradientLayer()

        selGradientLayer.frame = selectAudioAppButton.bounds
        selGradientLayer.colors = [selTopGradientColor.cgColor, selBottomGradientColor.cgColor]

        //Vertical
        selGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        selGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        selGradientLayer.locations = [0.0, 1.0]

        selectAudioAppButton.layer.insertSublayer(selGradientLayer, at: 0)
        selectAudioAppButton.layer.cornerRadius = 10
        selectAudioAppButton.clipsToBounds = true
        
        canGradientLayer.frame = cancelAudioAppButton.bounds

        canGradientLayer.colors = [canTopGradientColor.cgColor, canBottomGradientColor.cgColor]

        //Vertical
        canGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        canGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        cancelAudioAppButton.layer.insertSublayer(canGradientLayer, at: 0)
        cancelAudioAppButton.layer.cornerRadius = 10
        cancelAudioAppButton.clipsToBounds = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func returnToDashboardViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
}
