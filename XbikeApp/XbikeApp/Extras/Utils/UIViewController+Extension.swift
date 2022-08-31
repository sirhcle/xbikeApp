//
//  UIViewController+Extension.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 29/08/22.
//

import Foundation
import UIKit

extension UIViewController {
    func alertPermissionLocation() {
        let alertController = UIAlertController(title: "Permisos de localización requeridos", message: "Por favor habilite los permisos en la configuración", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
