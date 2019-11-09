//
//  CellSlidingImages.swift
//  LeonExample
//
//  Created by yusef naser on 10/26/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit


protocol IsScrollEnableDelegate : class  {
    
    func dismissLeon()
}



class CellSlidingImages : UICollectionViewCell {
    
    var imageURL : Any? = nil
    var startFrame : CGRect!
    var startImage : UIImage!
    private var doubleGestureRecognizer: UITapGestureRecognizer!
    private var singleGestureRecognizer : UITapGestureRecognizer!
    var originalFrameForGeneratedSHowImage : CGRect?
    
    weak var delegate : IsScrollEnableDelegate?
    
    private var sessionLoadImage : URLSessionDataTask?
    
    var errorMessage : String = "" {
        didSet {
            self.imageView.errorMessage = self.errorMessage
        }
    }
    
    var tapToReload : Bool = true
    
    
    var startWithAnimation : Bool {
        return self.startFrame != nil
    }
    
    var withStartImage : Bool {
        return self.startImage != nil
    }
    
    
    
    lazy var imageView : LeonImageView = {
        let image : LeonImageView!
        
        if self.startWithAnimation  {
            image = LeonImageView(frame: self.startFrame! )
        }else {
            image = LeonImageView()
            let height = UIScreen.main.bounds.height / 3
            let y = self.contentView.frame.height / 2 - ( height / 2 )
            image.frame = CGRect(x: 0, y: y , width: self.contentView.frame.width , height: height )
            self.originalFrameForGeneratedSHowImage = image.frame
            image.alpha = 0
        }
        
        if self.withStartImage {
            image.image = self.startImage!
        }else if let s = self.imageURL ,let ss =  s as? String  {
            sessionLoadImage = image.imageFromServerURL(urlString: ss )
        }
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
        
    }()
    
    lazy var scrollView : UIScrollView = {
        let s = UIScrollView()
        s.delegate = self
        s.alwaysBounceVertical = false
        s.alwaysBounceHorizontal = false
        s.showsVerticalScrollIndicator = true
        s.flashScrollIndicators()
        s.backgroundColor = .black
        s.minimumZoomScale = 1.0
        s.maximumZoomScale = 5.0
        
        doubleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleGestureRecognizer.numberOfTapsRequired = 2
        
        singleGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(handleSingleTap))
        
        self.doubleGestureRecognizer.delegate = self
        self.singleGestureRecognizer.delegate = self
        
        s.addGestureRecognizer(doubleGestureRecognizer)
        s.addGestureRecognizer(singleGestureRecognizer)
        
        
        s.addSubview(self.imageView)
        return s
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func loadImage (image : Any) {
        self.imageURL = image
        if let i = image as? UIImage {
            self.imageView.image = i
        }else if let i = image as? String {
            self.sessionLoadImage = self.imageView.imageFromServerURL(urlString: i)
        }
    }
    
    
    func addViews () {
        self.contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor , constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor , constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor , constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: 0).isActive = true
        animateIn()
    }
    
    
    
    
    func animateIn () {
        UIView.animate(withDuration:  0.3 , animations: {
            self.scrollView.backgroundColor = .black
            if self.startWithAnimation  {
                // let height = (self.view.frame.height / self.imageView.frame.width) * self.imageView.frame.height
                let height = UIScreen.main.bounds.height / 3
                let y = self.contentView.frame.height / 2 - ( height / 2 )
                self.imageView.frame = CGRect(x: 0, y: y , width: self.contentView.frame.width , height: height )
                self.originalFrameForGeneratedSHowImage = self.imageView.frame
            }else {
                self.imageView.alpha = 1
            }
            
        }) { (bool) in
            
            if self.withStartImage , let s = self.imageURL as? String  {
                self.sessionLoadImage = self.imageView.imageFromServerURL(urlString: s )
            } else if let s = self.imageURL as? UIImage {
                self.imageView.image = s
            }
            
            
        }
        
    }
    
    func animateOutTop () {
        
        UIView.animate(withDuration: 0.3 , animations: {
            self.contentView.backgroundColor = .clear
            //  self.imageView.frame = self.startFrame
            self.imageView.frame.origin.y = -self.contentView.frame.height
        }) { (bool) in
            print("dismiss")
            self.delegate?.dismissLeon()
            self.sessionLoadImage?.cancel()
            //  self.dismiss(animated: true )
            //  self.finishVC?(true )
        }
    }
    
    func animateOutBottom () {
        
        UIView.animate(withDuration: 0.3 , animations: {
            self.contentView.backgroundColor = .clear
            //  self.imageView.frame = self.startFrame
            self.imageView.frame.origin.y = self.contentView.frame.height
        }) { (bool) in
            print("dismiss")
            self.delegate?.dismissLeon()
            self.sessionLoadImage?.cancel()
            //  self.dismiss(animated: true )
            //  self.finishVC?(true )
        }
    }
    
    func animateOut () {
        
        UIView.animate(withDuration: 0.3 , animations: {
            self.contentView.backgroundColor = .clear
            if self.startWithAnimation {
                self.imageView.frame = self.startFrame!
            }else {
                self.imageView.alpha = 0
            }
            
        }) { (bool) in
            self.delegate?.dismissLeon()
            self.sessionLoadImage?.cancel()
            self.sessionLoadImage?.cancel()
        }
    }
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width)/2
            
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height{
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height)/2
        }else{
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
    }
    
    
    @objc func handleDoubleTap() {
        
        if self.imageView.errorLoading {
            return
        }
        
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale( 3 , center: doubleGestureRecognizer.location(in: doubleGestureRecognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    @objc private func handleSingleTap () {
        if imageView.errorLoading && tapToReload , let s = self.imageURL as? String {
            self.sessionLoadImage = self.imageView.imageFromServerURL(urlString: s )
            return
        }
        
        if scrollView.zoomScale != 1 {
            scrollView.setZoomScale(1, animated: true)
            
        }
    }
    
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    
}

extension CellSlidingImages : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.imageView.errorLoading {
            return
        }
        centerScrollViewContents()
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        if self.imageView.errorLoading {
            return
        }
    }
}


//extension UIImage {
//    var averageColor: UIColor? {
//        guard let inputImage = CIImage(image: self) else { return nil }
//        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
//        
//        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
//        guard let outputImage = filter.outputImage else { return nil }
//        
//        var bitmap = [UInt8](repeating: 0, count: 4)
//        let context = CIContext(options: [.workingColorSpace: kCFNull])
//        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
//        
//        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
//    }
//}


extension UICollectionViewCell {
    
    public static func getID () -> String {
        return String(describing: self )
    }
    
}

extension CellSlidingImages : UIGestureRecognizerDelegate {
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleGestureRecognizer && otherGestureRecognizer == self.doubleGestureRecognizer {
            return false
        }
        
        //        if gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == scrollView.pinchGestureRecognizer {
        //            return false
        //        }
        
        return true
    }
    
}

