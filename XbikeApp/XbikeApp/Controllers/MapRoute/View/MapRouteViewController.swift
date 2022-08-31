//
//  MapRouteViewController.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 28/08/22.
//

import UIKit
import GoogleMaps
import CoreLocation
import PTTimer

class MapRouteViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var mapRouterViewModel: MapRouterViewModel = MapRouterViewModel()
    
    var viewChronom: ChronometerStartView!
    var viewResumen: ChronometerResume!
    var viewFinalText: ChronometerStoredView!
    
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var goCurrentLocationCamera = true
    var callsUpdate = 0
    var address1 = ""
    var address2 = ""
    var hasAddress1 = false
    var hasAddress2 = false
    var traveledDistance: Double = 0
    var runingRoute = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.checkPermissionsLocation()
        self.configureView()
    }
    
    func configureView() {
        self.checkDevice()
        self.setupUI()
        self.mapRouterViewModel.checkLocationPermission()
    }
    
    
    func checkPermissionsLocation() {
        self.mapRouterViewModel.notPermission = { [weak self] () in
            DispatchQueue.main.async {
                self?.alertPermissionLocation()
            }
        }
    }
    
    //MARK: - configureView
    
    func checkDevice() {
        #if targetEnvironment(simulator)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 52.103209822026066, longitude: 5.131748760662314)
        marker.map = mapView
        #endif
    }
    
    func setupUI() {
        viewChronom = ChronometerStartView()
        viewChronom.translatesAutoresizingMaskIntoConstraints = false
        self.viewChronom.delegate = self
        
        viewResumen = ChronometerResume()
        viewResumen.translatesAutoresizingMaskIntoConstraints = false
        self.viewResumen.delegate = self
        
        viewFinalText = ChronometerStoredView()
        viewFinalText.translatesAutoresizingMaskIntoConstraints = false
        viewFinalText.delegate = self
        
        viewChronom.isHidden = true
        viewResumen.isHidden = true
        viewFinalText.isHidden = true
        
        self.view.addSubview(viewChronom)
        self.view.addSubview(viewResumen)
        self.view.addSubview(viewFinalText)
        
        
        NSLayoutConstraint.activate([
            viewChronom.heightAnchor.constraint(equalToConstant: 180),
            viewChronom.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            viewChronom.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            viewChronom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
        ])
        
        NSLayoutConstraint.activate([
            viewResumen.heightAnchor.constraint(equalToConstant: 300),
            viewResumen.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            viewResumen.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            viewResumen.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            viewFinalText.heightAnchor.constraint(equalToConstant: 300),
            viewFinalText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            viewFinalText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            viewFinalText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    //MARK: - REVERSE GEOCODING
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, labelShow: Int) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            guard let address = response?.firstResult(),
                  let lines = address.lines else { return }
          
            if labelShow == 1 {
              self.address1 = lines.joined(separator: "\n")
            } else {
              self.address2 = lines.joined(separator: "\n")
            }
        
        
            UIView.animate(withDuration: 0.25) {
              self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionNewRide(_ sender: Any) {
        self.viewChronom.isHidden = false
        self.viewResumen.isHidden = true
        self.viewFinalText.isHidden = true
    }
}

extension MapRouteViewController: ChronometerStartViewDelegate {
    
    func startChronometer() {
        self.goCurrentLocationCamera = true
        self.hasAddress1 = false
        self.hasAddress2 = false
        self.runingRoute = true
        self.viewChronom.startChronom()
        self.locationManager.requestLocation()
    }
    
    func stopChronometer(totalTime: String) {
        self.viewChronom.isHidden = true
        self.viewResumen.isHidden = runingRoute ? false : true
        self.viewFinalText.isHidden = true
        
        if runingRoute {
            self.viewChronom.timer.pause()
            
            let distanceReal = traveledDistance / 1000
            let doubleStr = String(format: "%.3f", distanceReal)
            let distanceFormated = "\(doubleStr) Km"
            
            let model: ChronometerResumeModel = ChronometerResumeModel(totalTime: totalTime, distance: distanceFormated)
            self.viewResumen.setModel(model: model)
        } else {
            self.viewChronom.timer.reset()
            self.mapView.clear()
            self.startLocation = nil
            self.lastLocation = nil
            self.traveledDistance = 0
            self.hasAddress1 = false
            self.hasAddress2 = false
            self.runingRoute = false
            self.viewChronom.resetView()
            self.viewResumen.resetView()
        }
    }
}

extension MapRouteViewController: ChronometerResumeDelegate {
    func storeRide(model: ChronometerResumeModel) {
        
        let mapRouteModel = MapRouteModel(time: model.totalTime, addressA: self.address1, addressB: self.address2, distance: model.distance)
        
        self.mapRouterViewModel.storeRide(mapRouteModel: mapRouteModel)
        self.viewChronom.isHidden = true
        self.viewResumen.isHidden = true
        self.viewFinalText.isHidden = false
    }
    
    func deleteRide() {
        self.viewChronom.isHidden = true
        self.viewResumen.isHidden = true
        self.viewFinalText.isHidden = true
        
        self.viewChronom.timer.reset()
        self.mapView.clear()
        self.startLocation = nil
        self.lastLocation = nil
        self.traveledDistance = 0
        self.hasAddress1 = false
        self.hasAddress2 = false
        self.runingRoute = false
        self.viewChronom.resetView()
        self.viewResumen.resetView()
    }
}

extension MapRouteViewController: ChronometerStoredViewDelegate {
    func closeView() {
        self.viewChronom.isHidden = true
        self.viewResumen.isHidden = true
        self.viewFinalText.isHidden = true
        
        self.viewChronom.timer.reset()
        self.mapView.clear()
        self.startLocation = nil
        self.lastLocation = nil
        self.traveledDistance = 0
        self.hasAddress1 = false
        self.hasAddress2 = false
        self.runingRoute = false
        self.viewChronom.resetView()
        self.viewResumen.resetView()
    }
}


extension MapRouteViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        lastLocation = locations.last
        
        if goCurrentLocationCamera {
//            goCurrentLocationCamera = false
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
        }
        
        if self.viewChronom.timer.state == .running {
            if startLocation == nil {
                startLocation = locations.first!
            } else {
                let lastLocation = locations.last!
                let distance = startLocation.distance(from: lastLocation)

                let path = GMSMutablePath()
                path.add(CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude))
                path.add(CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude))

                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor.init(hex: "#FF8E25FF") ?? .orange
                polyline.strokeWidth = 5.0
                polyline.map = mapView

                startLocation = lastLocation

                callsUpdate += 1

                if callsUpdate > 3 {
                    traveledDistance += distance
                }

            }
        }

        if !hasAddress1 && self.viewChronom.timer.state == .running {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = "Inicio"
            marker.map = mapView
            hasAddress1 = true
            reverseGeocodeCoordinate(GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0).target, labelShow: 1)
        }else {
            if self.viewChronom.timer.state == .paused && !hasAddress2 {

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                marker.title = "Fin"
                marker.map = mapView

                hasAddress2 = true
                reverseGeocodeCoordinate(GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0).target, labelShow: 2)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
