//
//  ChronometerStored.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 29/08/22.
//

import UIKit

protocol ChronometerStoredViewDelegate {
    func closeView()
}

class ChronometerStoredView: UIView {
    
    lazy var lblTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Abel-Regular", size: 25.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var btnStop: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.init(hex: "#BDBDBDFF"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Abel-Regular", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var delegate: ChronometerStoredViewDelegate!
    
    init(){
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        
        self.lblTitle.text = "Your progress has been correctly stored!"
        self.btnStop.setTitle("OK", for: .normal)
        self.btnStop.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        self.addSubview(lblTitle)
        self.addSubview(btnStop)
        
        self.layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            self.lblTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.lblTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            self.btnStop.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.btnStop.heightAnchor.constraint(equalToConstant: 50),
            self.btnStop.widthAnchor.constraint(equalToConstant: 100),
            self.btnStop.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.btnStop.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        ])
    }
    
    //MARK: - ACTIONS
    
    @objc func closeView() {
        if let delegate = self.delegate {
            delegate.closeView()
        }
    }
    
}
