//
//  MapRouteModel.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 30/08/22.
//

import Foundation


struct MapRouteModel:Codable {
    let time: String?
    let addressA: String?
    let addressB: String?
    let distance: String?
}

struct ListMapRoute:Codable {
    let listMapRoute: [MapRouteModel?]
}

struct RouteModel {
    var routeModel: MapRouteModel
}
