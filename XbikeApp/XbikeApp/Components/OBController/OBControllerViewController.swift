//
//  OBControllerViewController.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 24/08/22.
//

import Foundation
import UIKit

protocol OBControllerDelegate {
    func dismissOB()
}

public class OBControllerViewController: UIViewController {
    
    var model: OBControllerModel!
    var delegate: OBControllerDelegate!
    
    lazy var lblTextTitle: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Abel-Regular", size: 32.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let containerView: UIView = UIView(frame: .zero)
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Abel-Regular", size: 25.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    convenience init(model: OBControllerModel) {
        self.init()
        self.model = model
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecore: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#FF8E25FF")
        self.setup()
    }
    
    func setup() {
        self.lblTextTitle.text = self.model.title
        self.imageView.image = UIImage(named: self.model.image)
        
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(lblTextTitle)
        
        self.view.addSubview(self.containerView)
        
        self.layout()
        
        if model.buttonTitle != "" {
            self.button.setTitle(self.model.buttonTitle, for: .normal)
            self.button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
            self.view.addSubview(self.button)
            self.layoutButton()
        }
    }
    
    @objc func dismissOnboarding() {
        if let delegate = self.delegate {
            delegate.dismissOB()
        }
    }
    
    func layout(){
        
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalToConstant: 300),
            self.containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            self.containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
            self.containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0),
            
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.imageView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.imageView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.imageView.heightAnchor.constraint(equalToConstant: 100.0),
            self.imageView.widthAnchor.constraint(equalToConstant: 100.0),
            
            self.lblTextTitle.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 0),
            self.lblTextTitle.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.lblTextTitle.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.lblTextTitle.heightAnchor.constraint(equalToConstant: 180.0)
        ])
        
    }
    
    func layoutButton(){
        
        NSLayoutConstraint.activate([
            self.button.heightAnchor.constraint(equalToConstant: 50),
            self.button.widthAnchor.constraint(equalToConstant: 150),
            self.button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0),
            self.button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0),
        ])
        
    }
    
    
    
}
