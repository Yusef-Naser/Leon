//
//  CloseView.swift
//  LeonExample
//
//  Created by yusef naser on 11/18/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit

open class CloseView : UIView {
    
    
    lazy var horizontalView : UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 1
        return v
    }()
    
    lazy var verticalView : UIView = {
       let v = UIView ()
        v.backgroundColor = .white
         v.layer.cornerRadius = 1
        
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        horizontalView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        verticalView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.backgroundColor = .clear
        
        self.addSubview(horizontalView)
        self.addSubview(verticalView)
        
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        horizontalView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 0).isActive = true
        horizontalView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        horizontalView.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 0).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        verticalView.translatesAutoresizingMaskIntoConstraints = false
        verticalView.topAnchor.constraint(equalTo: self.topAnchor , constant: 0 ).isActive = true
        verticalView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 0).isActive = true
        verticalView.centerXAnchor.constraint(equalTo: self.centerXAnchor , constant: 0).isActive = true
        verticalView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    
}


open class ContainerCloseView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    private func initViews () {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.597243618)
        self.layer.cornerRadius = 35 / 2
        
        let close = CloseView()
        
        self.addSubview(close )
        
        close.translatesAutoresizingMaskIntoConstraints = false
        close.centerXAnchor.constraint(equalTo: self.centerXAnchor , constant: 0).isActive = true
        close.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 0).isActive = true
        close.heightAnchor.constraint(equalToConstant: 20).isActive = true
        close.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        self.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        
    }
    
}
