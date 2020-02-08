//
//  LeonImageView.swift
//  LeonExample
//
//  Created by yusef naser on 10/26/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit

class LeonImageView : UIImageView {
    
    var errorMessage : String = "Loading Error, tap to reload"
    var errorLoading : Bool = false
    
    lazy private var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor ).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor ).isActive = true
        return indicator
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func imageFromServerURL(urlString: String) -> URLSessionDataTask {
        //  self.image = nil
        self.startLoading()
        self.removeLoadingErrorView()
        let session = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self.stopLoading()
                if error != nil {
                       d( "error loading" + error!.localizedDescription )
                    self.addLoadingError()
                    
                    return
                }
                self.removeLoadingErrorView()
                let image = UIImage(data: data!)
                self.image = image
            })
            
        })
        session.resume()
        
        return session
        
    }
    
    private func startLoading () {
        self.indicator.startAnimating()
    }
    
    private func stopLoading () {
        self.indicator.stopAnimating()
    }
    
    
    private func removeLoadingErrorView () {
        self.subviews.forEach { (view) in
            if view.tag == 1000  {
                self.errorLoading = false
                self.backgroundColor = .clear
                view.removeFromSuperview()
            }
        }
    }
    
    
    private func addLoadingError () {
        self.image = nil
        errorLoading = true
        let v = createLoadingError()
        v.tag = 1000
        self.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.centerXAnchor.constraint(equalTo: self.centerXAnchor , constant: 0).isActive = true
        v.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 0).isActive = true
        
    }
    
    
    private func createLoadingError () -> UIView {
        let v = UIView()
        self.backgroundColor = .black
        v.backgroundColor = .black
        v.layer.cornerRadius = 10
        let l = UILabel()
        l.textColor = .white
        l.text =  errorMessage
        l.textAlignment = .center
        v.addSubview(l)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.topAnchor.constraint(equalTo: v.topAnchor , constant: 4).isActive = true
        l.bottomAnchor.constraint(equalTo: v.bottomAnchor , constant: -4).isActive = true
        l.leadingAnchor.constraint(equalTo: v.leadingAnchor , constant: 16 ).isActive = true
        l.trailingAnchor.constraint(equalTo: v.trailingAnchor , constant: -16 ).isActive = true
        
        return v
        
    }
    
    
    
    
}
