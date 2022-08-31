//
//  RecordViewCell.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 30/08/22.
//

import UIKit

class RecordViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    public var routeModel: RouteModel? {
        didSet {
            setup()
        }
    }
    
    func setup() {
        self.lblTime.text = routeModel?.routeModel.time
        self.lblDistance.text = routeModel?.routeModel.distance
        self.lblAddress.text = "A. \(routeModel?.routeModel.addressA ?? "") \nB. \(routeModel?.routeModel.addressB ?? "")"
    }

}
