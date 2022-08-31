//
//  ChronometerResume.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 29/08/22.
//

import UIKit

struct ChronometerResumeModel {
    var totalTime: String = ""
    var distance: String = ""
    
    init(totalTime: String, distance: String) {
        self.totalTime = totalTime
        self.distance = distance
    }
}

protocol ChronometerResumeDelegate {
    func storeRide(model: ChronometerResumeModel)
    func deleteRide()
}

class ChronometerResume: UIView {
    
    lazy var lblTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Abel-Regular", size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lblTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Abel-Regular", size: 35.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lblTxtDistance: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Abel-Regular", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblDistance: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Abel-Regular", size: 35.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var btnStart: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.init(hex: "#FF8E25FF"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Abel-Regular", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var btnStop: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.init(hex: "#BDBDBDFF"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Abel-Regular", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#FF8E25FF")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var model: ChronometerResumeModel! = ChronometerResumeModel(totalTime: "00:00:00", distance: "0.0 km")
    var delegate: ChronometerResumeDelegate!
    
    
    //MARK: - Init
    
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
    
    public func setModel(model: ChronometerResumeModel) {
        self.model = model
        self.setup()
    }
    
    func setup(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        
        self.lblTitle.text = "Your time was"
        self.lblTime.text = self.model.totalTime
        self.lblTxtDistance.text = "Distante"
        self.lblDistance.text = self.model.distance
        
        self.btnStart.setTitle("STORE", for: .normal)
        self.btnStart.addTarget(self, action: #selector(storeRide), for: .touchUpInside)
        self.btnStop.setTitle("DELETE", for: .normal)
        self.btnStop.addTarget(self, action: #selector(deleteRide), for: .touchUpInside)
        
        
        self.addSubview(lblTitle)
        self.addSubview(lblTime)
        self.addSubview(lblTxtDistance)
        self.addSubview(lblDistance)
        self.addSubview(btnStart)
        self.addSubview(lineView)
        self.addSubview(btnStop)
        
        self.layout()
    }
    
    public func resetView() {
        self.model = ChronometerResumeModel(totalTime: "00:00:00", distance: "0.0 km")
        self.setup()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.lblTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.lblTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            self.lblTime.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 10),
            self.lblTime.leftAnchor.constraint(equalTo: self.lblTitle.leftAnchor, constant: 20),
            self.lblTime.rightAnchor.constraint(equalTo: self.lblTitle.rightAnchor, constant: -20),
            
            self.lblTxtDistance.topAnchor.constraint(equalTo: self.lblTime.bottomAnchor, constant: 15),
            self.lblTxtDistance.leftAnchor.constraint(equalTo: self.lblTime.leftAnchor, constant: 20),
            self.lblTxtDistance.rightAnchor.constraint(equalTo: self.lblTime.rightAnchor, constant: -20),
            
            self.lblDistance.topAnchor.constraint(equalTo: self.lblTxtDistance.bottomAnchor, constant: 10),
            self.lblDistance.leftAnchor.constraint(equalTo: self.lblTxtDistance.leftAnchor, constant: 20),
            self.lblDistance.rightAnchor.constraint(equalTo: self.lblTxtDistance.rightAnchor, constant: -20),
            
            
            self.btnStart.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.btnStart.heightAnchor.constraint(equalToConstant: 50),
            self.btnStart.widthAnchor.constraint(equalToConstant: 100),
            self.btnStart.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            
            self.lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.lineView.heightAnchor.constraint(equalToConstant: 50),
            self.lineView.widthAnchor.constraint(equalToConstant: 2),
            self.lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            self.btnStop.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.btnStop.heightAnchor.constraint(equalToConstant: 50),
            self.btnStop.widthAnchor.constraint(equalToConstant: 100),
            self.btnStop.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
            
        
        ])
    }
    
    //MARK: - ACTIONS
    
    @objc func storeRide() {
        if let delegate = self.delegate {
            delegate.storeRide(model: self.model)
        }
    }
    
    @objc func deleteRide() {
        if let delegate = self.delegate {
            delegate.deleteRide()
        }
    }

    
}
