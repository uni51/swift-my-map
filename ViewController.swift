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
                            
                            // 取得した位置情報の緯度経度
                            let latitude = targetCoordinate.latitude
                            let longitude = targetCoordinate.longitude
                            let location = CLLocationCoordinate2DMake(latitude,longitude)
                            
                            // 表示するマップの中心を、取得した位置情報のポイントに指定
                            self.dispMap.setCenter(location, animated: true)
                            
                            // 表示する領域を設定する
                            var region: MKCoordinateRegion = self.dispMap.region
                            // 領域設定の中心
                            region.center = location
                            // 表示する領域の拡大・縮小の係数
                            region.span.latitudeDelta = 0.01
                            region.span.longitudeDelta = 0.01
                            
                            // ピンのオブジェクトを生成
                            let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                            
                            // ピンの位置を取得した位置情報の位置に設定
                            pointAnnotation.coordinate = location
                            // ピンをタップした際に表示される吹き出しの内容
                            pointAnnotation.title = searchKey
                            
                            // 設定したピンをマップ上に反映
                            self.dispMap.addAnnotation(pointAnnotation)
                            // 決定した表示設定をMapViewに適用
                            self.dispMap.setRegion(region, animated: true)
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
