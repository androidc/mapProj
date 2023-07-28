//Created by chizztectep on 25.07.2023 

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Global Vars
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var locationManager: CLLocationManager?
    var geocoder: CLGeocoder?
    
    // MARK: - Outlets

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func AddMarker(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2D(latitude: 55.853215, longitude:37.522504)
        if marker == nil {
            addMarker(coord: coordinate)
        } else {
            removeMarker()
        }
    }
    
    @IBAction func MoveToButtonAction(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2D(latitude: 55.853215, longitude:37.522504)
        // Создаём камеру с использованием координат и уровнем увеличения
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        // Устанавливаем камеру для карты
       // mapView.camera = camera
        //mapView.isTrafficEnabled = true
       // mapView.mapType = .satellite
        
        mapView.animate(toLocation: coordinate)
    }
    
    @IBAction func CurrentLocationButtonAction(_ sender: UIButton) {
        locationManager?.requestLocation()
    }
    
    
    @IBAction func UpdateLocationButtonAction(_ sender: UIButton) {
        
        locationManager?.startUpdatingLocation()
    }
    
    // MARK: - Functions
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        geocoder = CLGeocoder()
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    func addMarker(coord: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coord)
     //   marker.title = "го я создал"
        marker.map = mapView
        self.marker = marker
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        // Создаём камеру с использованием координат и уровнем увеличения
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        // Устанавливаем камеру для карты
        mapView.camera = camera
        mapView.delegate = self
        configureLocationManager()
    }
}

extension ViewController: GMSMapViewDelegate {
func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
print(coordinate)
    // Если маркер уже создан, меняем его позицию
    if let manualMarker = manualMarker {
        manualMarker.position = coordinate
    } else {
        // Если маркера нет, то создаём его
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            self.manualMarker = marker
    }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    // 6. При изменении местоположения сдвигать карту так, чтобы ваше местоположение было в её центре.
    //7. При изменении местоположения добавлять стандартный маркер на карту.

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        //camera  = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(toLocation: location.coordinate)
        addMarker(coord: location.coordinate)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations.first)
//        guard let location = locations.last else { return }
//            geocoder?.reverseGeocodeLocation(location) { places, error in
//                    print(places?.first)
//            }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

