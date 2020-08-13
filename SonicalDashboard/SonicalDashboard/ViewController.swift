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
    @IBOutlet var draggableView: AADraggableView!
    @IBOutlet var systemPickerView: UIPickerView!
    
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
        //print(testView.center)
        //if (testView.frame.contains(sender.center)) {
          //  sender.center = testView.center
          //  testView.backgroundColor = UIColor.red
        //}
        //sender.center = CGPoint(x: 150, y: 150)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemPickerView.delegate = self
        systemPickerView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Set options
        draggableView.delegate = self // AADraggableViewDelegate
        draggableView.respectedView = respectedView// reference view
        draggableView.reposition = .sticky// Reposition option
        draggableView.repositionIfNeeded() // Auto correct reposition
        respectedView.bringSubviewToFront(draggableView)
        draggableView.layer.zPosition = 1000
    }
}
