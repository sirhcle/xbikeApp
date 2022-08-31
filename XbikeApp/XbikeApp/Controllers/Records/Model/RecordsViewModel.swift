//
//  RecordsViewModel.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 31/08/22.
//

import Foundation

class RecordsListViewModel {
    
    var records: [MapRouteModel?]
    
    init() {
        records = MapRouterViewModel().getAllRides()
    }
    
    var count: Int { records.count }
    
    func recordsViewModel(at index: Int) -> RouteModel {
        return RouteModel(routeModel: records[index] ?? MapRouteModel(time: "", addressA: "", addressB: "", distance: ""))
    }
    
}
