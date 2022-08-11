//
//  TheaterViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/12.
//

import UIKit
import MapKit
import CoreLocation

class TheaterViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //새싹위치로 디폴트
        //let center = CLLocationCoordinate2D(latitude: 37.517829,  longitude: 126.886270)

        
        setRegionsAndAnnotations(info: TheaterList.mapAnnotations)
        
        locationManager.delegate = self
        
        checkUserDeviceLocationServiceAuthorization()

    }
    
  
}

extension TheaterViewController {
    // 중심 설정하기
    func setRegionAndAnnotation(center: CLLocationCoordinate2D, title: String) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1200, longitudinalMeters: 1200)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }
    
    func setRegionsAndAnnotations(info: [Theater]) {
        for item in info {
            setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), title: item.location)
        }
    }
    
    //사용자 위치서비스 사용확인
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // 위치서비스 활성화 되어 있을시, 권한 요청
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            // 위치서비스 X
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default :
            print(":)")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          // 애플이 설정창으로 갈 수 있게 제공해줌
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
        
        // 언제는 설정까지 가고 언제는 세부화면까지 이동할까?
        // 경험적으로는, 한번도 설정앱에 들어가지 않았거나 막 다운받은 앱일 경우 세부화면까지 이동하는 것 같다.
    }
}


extension TheaterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let center = locations.last?.coordinate as? CLLocationCoordinate2D {
            // 어노테이션
            setRegionAndAnnotation(center: center, title: "내 위치")
        }
        
        locationManager.stopUpdatingLocation()
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // ios 14이상일 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    }
    
}

extension TheaterViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}
