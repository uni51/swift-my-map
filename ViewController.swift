//
//  ViewController.swift
//  MyMap
//
//  Created by STARBOARD on 2019/05/17.
//  Copyright © 2019年 omokaji. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる(1)
        textField.resignFirstResponder()
        
        // 入力された文字を取り出す(2)
        if let searchKey = textField.text {
            // 入力された文字をデバッグエリアに表示(3)
            print(searchKey)
            
            // CLGeocoderインスタンスを取得
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                
                // 位置情報が存在する場合は、unwrapPlacemarksに取り出す
                if let unwrapPlacemarks = placemarks {
                    
                    // 1件目の位置情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        // 位置情報を取り出す
                        if let location = firstPlacemark.location {
                            
                            // 位置情報から緯度経度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            
                            // 緯度経度をデバッグエリアに表示
                            print(targetCoordinate)
                            
                            let pin = MKPointAnnotation()
                            
                            pin.coordinate = targetCoordinate
                            
                            // 取得した位置情報の緯度経度
                            let latitude = targetCoordinate.latitude
                            let longitude = targetCoordinate.longitude
                            let location = CLLocationCoordinate2DMake(latitude,longitude)
                            
                            pin.title = searchKey
                            
                            self.dispMap.addAnnotation(pin)
                            
                            self.dispMap.region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
        }
        
        // デフォルト動作を行うのでtrueを返す
        return true
    }

    @IBAction func changeMapButton(_ sender: Any) {
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
    
}
