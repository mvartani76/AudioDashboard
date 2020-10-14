//
//  Constants.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 10/10/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import Foundation
import UIKit

enum ConstantsEnum {
    enum AppSettings {
        enum Colors {
            enum Buttons {
                static let saveTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
                static let saveBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
                static let canTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
                static let canBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
                static let unselectedAudioAppColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1.0)
                static let selectedAudioAppColor = UIColor(red: 64/255, green: 62/255, blue: 61/255, alpha: 1.0)
            }
        }
        enum CornerRadius {
            enum Buttons {
                static let saveParamsButtonCornerRadius = CGFloat(10)
                static let cancelParamsButtonCornerRadius = CGFloat(10)
                static let paramButtonItemCornerRadius = CGFloat(10)
            }
            enum ImageView {
                static let appSettingsVCImageViewCornerRadius = CGFloat(10)
            }
        }
        enum Fonts {
            static let descriptionLabelFont = UIFont(name: "CourierNewPSMT", size: 30)
            static let paramButtonTitleLabelFont = UIFont(name: "CourierNewPSMT", size: 30)
            static let paramTitleLabelFont = UIFont(name: "CourierNewPSMT", size: 30)
            static let sliderTextLabelFont = UIFont(name: "CourierNewPSMT", size: 30)
        }
        enum Constraints {
            static let paramsTitleWidthMultiplier = CGFloat(1.0)
            static let paramsGUIWidthMultiplier = CGFloat(1.0)
            static let paramsTitleHeightMultiplier = CGFloat(1.0)
            static let paramsGUIHeightMultiplier = CGFloat(2.0)
            static let buttonItemWidthMultiplier = CGFloat(0.8)
            static let buttonItemHeightMultiplier = CGFloat(0.8)
            static let paramTitleLabelWidthMultiplier = CGFloat(0.8)
            static let sliderStackViewWidthMultiplier = CGFloat(0.8)
            static let sliderStackViewHeightMultiplier = CGFloat(0.8)
            static let sliderItemHeightMultiplier = CGFloat(1.0)
            static let sliderTextLabelHeightMultiplier = CGFloat(1.0)
            static let sliderItemWidthMultiplier = CGFloat(4.0)
        }
    }

    enum AppDownload {
        enum Alpha {
            enum Buttons {
                static let selectAudioAppButtonAlphaUnselected = CGFloat(0.5)
                static let selectAudioAppButtonAlphaSelected = CGFloat(1.0)
            }
        }
        enum Colors {
            enum Buttons {
                static let selTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
                static let selBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
                static let canTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
                static let canBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
            }
            enum ImageView {
                static let tempSelectedAppBorderColor = UIColor.clear.cgColor
                static let currentSelectedAppBorderColor = UIColor.red.cgColor
            }
        }
        enum CornerRadius {
            enum Buttons {
                static let selectAudioAppButtonCornerRadius = CGFloat(10)
                static let cancelAudioAppButtonCornerRadius = CGFloat(10)
            }
        }
        enum Dimensions {
            static let borderWidth = CGFloat(5)
        }
    }

    enum ViewController {
        enum Colors {
            enum Buttons {
                static let frbTopGradientColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1)
                static let frbBottomGradientColor = UIColor(red: 128/255, green: 122/255, blue: 121/255, alpha: 1)
                static let unselectedAudioAppColor = UIColor(red: 148/255, green: 142/255, blue: 141/255, alpha: 1.0)
                static let selectedAudioAppColor = UIColor(red: 64/255, green: 62/255, blue: 61/255, alpha: 1.0)
            }
            enum MyApps {
                static let backgroundColor = UIColor.lightGray
                static let borderColor = UIColor.red.cgColor
            }
        }
        enum Fonts {
            static let pickerViewLabelFont = UIFont(name: "CourierNewPSMT", size: 32)
        }
        enum CornerRadius {
            enum Buttons {
                static let factoryResetButtonCornerRadius = CGFloat(10)
                static let addAppButtonCornerRadius = CGFloat(10)
            }
            enum ImageView {
                static let imageViewCornerRadius = CGFloat(10)
            }
            enum MyApps {
                static let postModalAppMyAppsCornerRadius = CGFloat(10)
            }
        }
        enum Frame {
            enum ImageView {
                static let height = 50
                static let width = 50
            }
            enum MyApps {
                static let height = 50
                static let width = 50
            }
        }
    }
    enum params {
        enum paramGUIType {
            static let button = 0
            static let slider = 1
        }
    }
}
