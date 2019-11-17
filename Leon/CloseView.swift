//
//  CloseView.swift
//  LeonExample
//
//  Created by yusef naser on 11/18/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit

class CloseView : UIView {
    
    
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

    required init?(coder aDecoder: NSCoder) {
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
