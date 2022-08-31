//
//  MapRouterViewModel.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 29/08/22.
//

import Foundation
import CoreLocation

class MapRouterViewModel{
    
    var notPermission = { () -> () in }
    
    var hasPermission: Bool = false {
        didSet {
            if !hasPermission {
                notPermission()
            }
        }
    }
    
    func checkLocationPermission() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                self.hasPermission = true
            @unknown default:
                self.hasPermission = false
                break
            }
        } else {
            self.hasPermission = false
        }
    }
    
    func storeRide(mapRouteModel: MapRouteModel) {
        let routes = self.getAllRides()
        
        var arrayRout : [MapRouteModel?] = [MapRouteModel]()
        arrayRout = routes
        arrayRout.append(mapRouteModel)
    
        let listRoute = ListMapRoute(listMapRoute: arrayRout)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(listRoute), forKey:"routes")
    }
    
    func getAllRides() -> [MapRouteModel?] {
        var arrayRoute : [MapRouteModel?] = [MapRouteModel]()
        if let data = UserDefaults.standard.value(forKey:"routes") as? Data {
            let listRoute = try? PropertyListDecoder().decode(ListMapRoute.self, from: data)
            for newRoute in listRoute?.listMapRoute ?? [] {
                arrayRoute.append(newRoute)
            }
            return arrayRoute
        }
        return [MapRouteModel?]()
    }
    
}
