//
//  OBControllerModel.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 24/08/22.
//

import Foundation

struct OBControllerModel {
    var image: String = ""
    var title: String = ""
    var buttonTitle: String = ""
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
    
    init(image: String, title: String, buttonTitle: String) {
        self.image = image
        self.title = title
        self.buttonTitle = buttonTitle
    }
}
