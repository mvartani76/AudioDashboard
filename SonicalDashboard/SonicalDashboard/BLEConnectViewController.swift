//
//  BLEConnectViewController.swift
//  SonicalDashboard
//
//  Created by Michael Vartanian on 10/15/20.
//  Copyright © 2020 Michael Vartanian. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEConnectViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!

    // Characteristics
    private var paramsChar: [CBCharacteristic?] = []
    
    var charArray: [String] = [""]

    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", Peripheral.peripheralParamServiceUUID);
            centralManager.scanForPeripherals(withServices: [Peripheral.peripheralParamServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to the Peripheral")
            peripheral.discoverServices([Peripheral.peripheralParamServiceUUID])
        }
    }

    // Handler for disconnects
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

        if peripheral == self.peripheral {
            print("Disconnected")
            // Set any GUI values to disabled here -- xxx.isEnabled = false

            self.peripheral = nil

            // Start scanning again
            print("Central scanning for", Peripheral.peripheralParamServiceUUID);
            centralManager.scanForPeripherals(withServices: [Peripheral.peripheralParamServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }

    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == Peripheral.peripheralParamServiceUUID {
                    print("Param service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([
                        Peripheral.param1CharacteristicUUID,
                        Peripheral.param2CharacteristicUUID,
                        Peripheral.param3CharacteristicUUID,
                        Peripheral.paramButtonCharacteristicUUID,
                        Peripheral.txCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }

    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == Peripheral.param1CharacteristicUUID {
                    print("Param 1 characteristic found")
                } else if characteristic.uuid == Peripheral.param2CharacteristicUUID {
                    print("Param 2 characteristic found")
                } else if characteristic.uuid == Peripheral.param3CharacteristicUUID {
                    print("Param 3 characteristic found");
                } else if characteristic.uuid == Peripheral.paramButtonCharacteristicUUID {
                    print("Param Button characteristic found");
                } else if characteristic.uuid == Peripheral.txCharacteristicUUID {
                    print("Tx characteristic found")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    // Handle notification updates
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
            case Peripheral.param1CharacteristicUUID:
                print("Param1 value = \(String(describing: characteristic.value))")
            case Peripheral.param2CharacteristicUUID:
                print("Param1 value = \(String(describing: characteristic.value))")
            case Peripheral.param3CharacteristicUUID:
                print("Param3 value = \(String(describing: characteristic.value))")
            case Peripheral.paramButtonCharacteristicUUID:
                print("ParamButton value = \(String(describing: characteristic.value))")
            case Peripheral.txCharacteristicUUID:
                // values are coming over as bytes from the peripheral so need to convert to whatever expected data type
                if let charStringTmp = String(bytes: characteristic.value!, encoding: .utf8) {
                    charArray.append(charStringTmp)
                    if charArray.count >= 5 {
                        charArray.remove(at: 0)
                    }
                    let stringPrint = charArray.joined(separator: "")

                    //rxTextLabel.text = stringPrint
                } else {
                    print("not a valid UTF-8 sequence")
                }
            default:
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

    // Handle peripheral modify services
    func peripheral(_ peripheral: CBPeripheral,
                    didModifyServices invalidatedServices: [CBService]) {
        print("Services Invalidated...")
        for service in invalidatedServices {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                        print(characteristic)
                    }
            }
        }
    }

    private func writeValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
        // Check if it has the write property
        // Still need to investigate how to send without response
        if characteristic.properties.contains(.write) && peripheral != nil {
            peripheral.writeValue(value, for: characteristic, type: .withResponse)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
