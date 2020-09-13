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

    @IBOutlet var musicApp1ImageView: UIImageView!
    @IBOutlet var musicApp2ImageView: UIImageView!
    @IBOutlet var musicApp3ImageView: UIImageView!

    @IBOutlet var hearingApp1ImageView: UIImageView!
    @IBOutlet var hearingApp2ImageView: UIImageView!
    @IBOutlet var hearingApp3ImageView: UIImageView!

    @IBOutlet var phoneApp1ImageView: UIImageView!
    @IBOutlet var phoneApp2ImageView: UIImageView!
    @IBOutlet var phoneApp3ImageView: UIImageView!

    var imageViewArray: [UIImageView] = []
    
    
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
        selectAudioAppButton.alpha = 0.5

        canGradientLayer.frame = cancelAudioAppButton.bounds

        canGradientLayer.colors = [canTopGradientColor.cgColor, canBottomGradientColor.cgColor]

        //Vertical
        canGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        canGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        cancelAudioAppButton.layer.insertSublayer(canGradientLayer, at: 0)
        cancelAudioAppButton.layer.cornerRadius = 10
        cancelAudioAppButton.clipsToBounds = true

        // set up touch enabled imageviews
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture6 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture7 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture8 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        let gesture9 = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        gesture1.numberOfTapsRequired = 1
        gesture1.isEnabled = true
        //musicA6pp1ImageView.isUserInteractionEnabled = true
        gesture1.cancelsTouchesInView = false
        gesture2.numberOfTapsRequired = 1
        gesture2.isEnabled = true
        //musicApp1ImageView.isUserInteractionEnabled = true
        gesture2.cancelsTouchesInView = false
        gesture3.numberOfTapsRequired = 1
        gesture3.isEnabled = true
        gesture3.cancelsTouchesInView = false

        gesture4.numberOfTapsRequired = 1
        gesture4.isEnabled = true
        gesture4.cancelsTouchesInView = false

        gesture5.numberOfTapsRequired = 1
        gesture5.isEnabled = true
        gesture5.cancelsTouchesInView = false

        gesture6.numberOfTapsRequired = 1
        gesture6.isEnabled = true
        gesture6.cancelsTouchesInView = false

        gesture7.numberOfTapsRequired = 1
        gesture7.isEnabled = true
        gesture7.cancelsTouchesInView = false

        gesture8.numberOfTapsRequired = 1
        gesture8.isEnabled = true
        gesture8.cancelsTouchesInView = false

        gesture9.numberOfTapsRequired = 1
        gesture9.isEnabled = true
        gesture9.cancelsTouchesInView = false

        musicApp1ImageView.addGestureRecognizer(gesture1)
        musicApp2ImageView.addGestureRecognizer(gesture2)
        musicApp3ImageView.addGestureRecognizer(gesture3)

        hearingApp1ImageView.addGestureRecognizer(gesture4)
        hearingApp2ImageView.addGestureRecognizer(gesture5)
        hearingApp3ImageView.addGestureRecognizer(gesture6)

        phoneApp1ImageView.addGestureRecognizer(gesture7)
        phoneApp2ImageView.addGestureRecognizer(gesture8)
        phoneApp3ImageView.addGestureRecognizer(gesture9)
        
        imageViewArray = [
            musicApp1ImageView,
            musicApp2ImageView,
            musicApp3ImageView,
            hearingApp1ImageView,
            hearingApp2ImageView,
            hearingApp3ImageView,
            phoneApp1ImageView,
            phoneApp2ImageView,
            phoneApp3ImageView]
    }

    //Action
    @objc func tapDetected(sender: UITapGestureRecognizer) {

        print("Selected App = \(SystemConfig.shared.tempSelectedApp)")
        
        if let tag = sender.view?.tag {
            print("Current App = \(tag)")
                imageViewArray[SystemConfig.shared.tempSelectedApp-1].layer.borderColor = UIColor.clear.cgColor
                imageViewArray[SystemConfig.shared.tempSelectedApp-1].setNeedsLayout()
                sender.view?.layer.borderColor = UIColor.red.cgColor
                sender.view?.layer.borderWidth = 5
                SystemConfig.shared.tempSelectedApp = tag
                selectAudioAppButton.alpha = 1.0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func selectAudioAppAndReturnToDashboardVC(_ sender: UIButton) {
        SystemConfig.shared.selectedApp = SystemConfig.shared.tempSelectedApp
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissAppDownloadModal"), object: nil)

        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    
    @IBAction func returnToDashboardViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
}
