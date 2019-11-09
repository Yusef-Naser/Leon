//
//  CustomLeonImages.swift
//  LeonExample
//
//  Created by yusef naser on 11/9/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit
import Leon

class CustomLeonImages : LeonImages {
    
    var isTapped = false
    
    // creating topView
    lazy var headerView : UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.7725490196, blue: 0.9411764706, alpha: 0.5)
        
        let b = UIButton()
        b.setTitle("close", for: .normal)
        b.addTarget(self , action: #selector(dismissController), for: .touchUpInside )
        v.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor , constant: 16).isActive = true
        b.leadingAnchor.constraint(equalTo: v.leadingAnchor , constant: 16).isActive = true
        
        let l = UILabel()
        l.text = "Title Header"
        l.textColor = .white
        v.addSubview(l)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.centerXAnchor.constraint(equalTo: v.centerXAnchor , constant: 0).isActive = true
        l.centerYAnchor.constraint(equalTo: v.centerYAnchor , constant: 0).isActive = true
        
        
        return v
    }()
    
    // creating bottomView
    lazy var footerView : UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 0.5)
        
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add header view and footerView on view
        self.view.addSubview(headerView)
        self.view.addSubview(footerView)
        
        // set constraints for headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: 0).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        // set constraints for footerView
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: 0).isActive = true
        footerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 0).isActive = true
        footerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: 0).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    @objc private func dismissController(){
        dismissLeon()
    }
    
    override func singleTapped() {
        if !isTapped {
            isTapped = true
            startPanGesture()
        }else {
            isTapped = false
            returnImageToCenter()
        }
        
    }
    
    
    // get pageIndex that appear on leonImages
    override var pageIndex: Int {
        didSet {
            print("pageIndex : \(self.pageIndex)")
        }
    }
    // excute this function when user began move with panGesture
    override func startPanGesture() {
        UIView.animate(withDuration: 0.3 ) { [weak self] in
            self?.headerView.alpha = 0
            self?.footerView.alpha = 0
        }
    }
    // excute this function when use leave panGesture and image return in center of screen
    override func returnImageToCenter() {
        UIView.animate(withDuration: 0.3 ) { [weak self] in
            self?.headerView.alpha = 1
            self?.footerView.alpha = 1
        }
    }
}

