//
//  ChronometerStart.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 28/08/22.
//

import UIKit
import PTTimer

protocol ChronometerStartViewDelegate {
    func startChronometer()
    func stopChronometer(totalTime: String)
}

class ChronometerStartView: UIView {

    lazy var lblTime: UILabel = {
        let label = UILabel()
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
    
    var delegate: ChronometerStartViewDelegate!
    var timer:PTTimer = PTTimer.Up()
    
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
        self.timer = PTTimer.Up()
        self.timer.delegate = self
        self.lblTime.text = "00:00:00"
        
        self.btnStart.setTitle("START", for: .normal)
        self.btnStart.addTarget(self, action: #selector(startChronometer), for: .touchUpInside)
        self.btnStop.setTitle("STOP", for: .normal)
        self.btnStop.addTarget(self, action: #selector(stopChronometer), for: .touchUpInside)
        
        self.addSubview(lblTime)
        self.addSubview(btnStart)
        self.addSubview(lineView)
        self.addSubview(btnStop)
        
        self.layout()
    }
    
    public func startChronom() {
        timer.start()
    }
    
    public func resetView() {
        self.lblTime.text = "00:00:00"
    }
    
    @objc func startChronometer() {
        
        if let delegate = self.delegate {
            delegate.startChronometer()
        }
    }
    
    @objc func stopChronometer() {
        
        if let delegate = self.delegate {
            
            let totalTime = self.lblTime.text ?? "00:00:00"
            delegate.stopChronometer(totalTime: totalTime)
        }
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            self.lblTime.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.lblTime.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.lblTime.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
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

    
}

extension ChronometerStartView: PTTimerDelegate {
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timerTimeDidChange(seconds: Int) {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
        var hora = ""
        var minuto = ""
        var segundos = ""
        
        if h < 10 {
            hora = "0\(h)"
        }else{
            hora = "\(h)"
        }
        
        if m < 10 {
            minuto = "0\(m)"
        }else{
            minuto = "\(m)"
        }
        
        if s < 10 {
            segundos = "0\(s)"
        }else{
            segundos = "\(s)"
        }
        
        self.lblTime.text = "\(hora):\(minuto):\(segundos)"
    }
    
    func timerDidPause() {}
    
    func timerDidStart() {}
    
    func timerDidReset() {}
}
