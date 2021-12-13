//
//  RouteController.swift
//  HospitalOne
//
//  Created by Daniil Belikov on 18.10.2019.
//  Copyright © 2019 Tolyatti City Hospital No.1. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

final class RouteController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var goButton: UIButton!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: - Public Properties
    
    let addressOfHospital = "Тольятти, ул. Октябрьская 68к2"
    let annotationIdentifier = "annotationIdentifier"
    
    let locationManager = CLLocationManager()
    let alertProvider = AlertProvider()
    
    var placeCoordinate: CLLocationCoordinate2D?
    var directionsArray: [MKDirections] = []
    
    var previousLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureObjects()
        mapViewDelegate()
        setupPlacemark()
        checkLocationServices()
    }
    
    // MARK: - IBActions
    
    @IBAction func walkButtonPressed() {
        getWalkDirection()
    }
    
    @IBAction func carButtonPressed() {
        getCarDirection()
    }
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
}

// MARK: - CLLocation Delegate Methods

extension RouteController: MKMapViewDelegate,
                           CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Determine the type of information window at the destination.
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0.0,
                                                  y: 0.0,
                                                  width: 50.0,
                                                  height: 50.0))
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "HospitalIcon.png")
        
        annotationView?.rightCalloutAccessoryView = imageView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Display the route line to the destination.
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 0.2431372549, green: 0.6352941176, blue: 0.8470588235, alpha: 1)
        renderer.lineWidth = 6.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        // Determine the center of the displayed area on the map.
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude,
                          longitude: longitude)
    }
    
    func resetMapView(withNew directions: MKDirections) {
        // Reset previously constructed routes before building a new route.
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    func carDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        // Configure the request for calculating the route (car).
        guard let destinationCoordinate = placeCoordinate else { return nil }
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    func walkDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        // Configure the request for calculating the route (walk).
        guard let destinationCoordinate = placeCoordinate else { return nil }
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        return request
    }
    
}

// MARK: - Private Configure Methods

private extension RouteController {
    
    func showUserLocation() {
        // Focus on the user's location.
        if let location = locationManager.location?.coordinate {
            let regionInMeters = 1000.00
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func checkLocationAuthorization() {
        // Check the authorization of the application to use the geolocation service.
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            DispatchQueue.main.async {
                self.alertProvider.showAlert(on: self,
                                             with: "Your location is not available".localize(),
                                             message: "To enable the location service, make changes to the phone settings.".localize())
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            return
        }
    }
    
    func startTrackingUserLocation() {
        // Change the displayed area of the map taking into account the movement of the user.
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation(for: mapView)
        
        guard center.distance(from: previousLocation) > 50.0 else { return }
        self.previousLocation = center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
        }
    }
    
    func getCarDirection() {
        // Pave the route from the user's location to the hospital.
        guard let location = locationManager.location?.coordinate else {
            alertProvider.showAlert(on: self,
                                    with: "Error".localize(),
                                    message: "Current location is not found.".localize())
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        guard let request = carDirectionRequest(from: location) else {
            alertProvider.showAlert(on: self,
                                    with: "Error".localize(),
                                    message: "Destination is not found.".localize())
            return
        }
        
        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions)
        
        directions.calculate { response, _ in
            guard let response = response else {
                self.alertProvider.showAlert(on: self,
                                             with: "Error".localize(),
                                             message: "Direction is not avaliable.".localize())
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%1.f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                let timeMin = Int(timeInterval / 60)
                let title = "Distance to the hospital – ".localize() + "\(distance)" + " km.".localize()
                let subtitle = "Travel time – ".localize() + "\(timeMin)" + " min.".localize()
                
                self.titleLable.text = title
                self.subtitleLabel.text = subtitle
                
                self.titleLable.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                self.subtitleLabel.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                
                self.titleLable.layer.cornerRadius = 5.0
                self.subtitleLabel.layer.cornerRadius = 5.0
                
                self.titleLable.clipsToBounds = true
                self.subtitleLabel.clipsToBounds = true
            }
        }
    }
    
    func getWalkDirection() {
        // Pave the route from the user's location to the hospital.
        guard let location = locationManager.location?.coordinate else {
            alertProvider.showAlert(on: self,
                                    with: "Error".localize(),
                                    message: "Current location is not found.".localize())
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude,
                                      longitude: location.longitude)
        
        guard let request = walkDirectionRequest(from: location) else {
            alertProvider.showAlert(on: self,
                                    with: "Error".localize(),
                                    message: "Destination is not found.".localize())
            return
        }
        
        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions)
        
        directions.calculate { response, _ in
            guard let response = response else {
                self.alertProvider.showAlert(on: self,
                                             with: "Error".localize(),
                                             message: "Direction is not avaliable.".localize())
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%1.f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                let timeMin = Int(timeInterval / 60)
                let title = "Distance to the hospital – ".localize() + distance + " km.".localize()
                let subtitle = "Travel time – ".localize() + String(timeMin) + " min.".localize()
                
                self.titleLable.text = title
                self.subtitleLabel.text = subtitle
                
                self.titleLable.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                self.subtitleLabel.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                
                self.titleLable.layer.cornerRadius = 5.0
                self.subtitleLabel.layer.cornerRadius = 5.0
                
                self.titleLable.clipsToBounds = true
                self.subtitleLabel.clipsToBounds = true
            }
        }
    }
    
    func configureObjects() {
        titleLable.text = ""
        subtitleLabel.text = ""
    }
    
    func mapViewDelegate() {
        mapView.delegate = self
    }
    
    func setupPlacemark() {
        // Find the location of the hospital on the map.
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressOfHospital) { placemarks, _ in
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = "Tolyatti City Hospital No.1".localize()
            annotation.subtitle = "68 Oktyabrskaya Street".localize()
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func checkLocationServices() {
        // Сheck the availability of the geolocation service.
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.async {
                self.alertProvider.showAlert(on: self,
                                             with: "Location service is not available".localize(),
                                             message: "To enable the location service, make changes to the phone settings.".localize())
            }
        }
    }
    
}
