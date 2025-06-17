import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    var searchKeyword: String = ""
    var currentLocation: CLLocationCoordinate2D?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        

        
        //searchNearbyRestaurants()
        print("1. searchKeyword: \(searchKeyword)")
        if !searchKeyword.isEmpty {
            searchNearbyRestaurants()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 2000,
                                            longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)

            locationManager.stopUpdatingLocation()
        }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let keyword = searchBar.text, !keyword.isEmpty,
              let userLocation = mapView.userLocation.location else {return}
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        let search  = MKLocalSearch(request: request)
        search.start { response, error in
            guard let items = response?.mapItems else {return}
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                if items.isEmpty {
                    let alert = UIAlertController(title: "not found", message: "'\(keyword)'",preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                for item in items {
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.coordinate = item.placemark.coordinate
                    self.mapView.addAnnotation(annotation)
                }
                
                DispatchQueue.main.async {
                    var annotations = self.mapView.annotations
                    
                    if let userLocation = self.mapView.userLocation.location {
                        let userAnnotation = MKPointAnnotation()
                        userAnnotation.coordinate = userLocation.coordinate
                        annotations.append(userAnnotation)
                    }
                    
                    self.mapView.showAnnotations(annotations, animated: true)
                }
                
                if !items.isEmpty {
                    // 모든 annotation을 추가한 후
                    print("items is not Empty")
                    let annotations = self.mapView.annotations.filter { !($0 is MKUserLocation) }
                    self.mapView.showAnnotations(annotations, animated: true)
                }

            }
        }
    }
    
    func searchNearbyRestaurants() {
        let coordinate: CLLocationCoordinate2D

        if let current = currentLocation {
            coordinate = current
        } else if let userLoc = mapView.userLocation.location?.coordinate {
            coordinate = userLoc
        } else {
            print("⚠️ 위치 정보 없음. 검색 불가")
            return
        }
        print("2. searchKeyword: \(searchKeyword)")
        print("currentLocation: \(String(describing: currentLocation))")
        let request = MKLocalSearch.Request()
        print("\(coordinate.latitude),\(coordinate.longitude)")
        request.naturalLanguageQuery = searchKeyword
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let items = response?.mapItems else {return}
            print("items count: \(items.count)")
            if items.isEmpty {
                print("item is Empty")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "결과 없음",
                        message: "주변에 해당 메뉴와 관련된 식당을 찾을 수 없습니다",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
            
            for item in items {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
            
            DispatchQueue.main.async {
                var annotations = self.mapView.annotations
                
                if let userLocation = self.mapView.userLocation.location {
                    let userAnnotation = MKPointAnnotation()
                    userAnnotation.coordinate = userLocation.coordinate
                    annotations.append(userAnnotation)
                }
                
                self.mapView.showAnnotations(annotations, animated: true)
            }
            
            if !items.isEmpty {
                print("items is not Empty")
                // 모든 annotation을 추가한 후
                let annotations = self.mapView.annotations.filter { !($0 is MKUserLocation) }
                self.mapView.showAnnotations(annotations, animated: true)
            }

        }
    }


}

extension MapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "place"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            view?.canShowCallout = true
            view?.pinTintColor = .red
        } else {
            view?.annotation = annotation
        }
        return view
    }
}
