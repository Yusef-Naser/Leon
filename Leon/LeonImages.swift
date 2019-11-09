//
//  LeonSlidingImages.swift
//  LeonExample
//
//  Created by yusef naser on 10/26/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit

open class LeonImages : UIViewController {
    
    var finishVC : ( () -> Void )?
    
    
    
    private var panGestureRecognizer : UIPanGestureRecognizer!
    open var pageIndex = -1
    private var selectedCell : CellSlidingImages?
    private var startFrame : CGRect!
    private var startImage : UIImage!
    private var listImagesURL : [Any] = []
    
    private var sessionLoadImage : URLSessionDataTask?
    
    var errorMessage : String = "Error loading, tap to reload"
    var tapToReload : Bool = true
    
    //    lazy var closeButton : UIButton = {
    //        let b = UIButton(type: .roundedRect)
    //        b.setTitle("close", for: .normal)
    //        b.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.696990537)
    //        b.layer.cornerRadius = 10
    //        b.addTarget(self , action: #selector(dismissView), for: .touchUpInside)
    //        return b
    //    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let c = UICollectionView(frame: .zero , collectionViewLayout: layout )
        c.isPagingEnabled = true
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = .clear
        c.register(CellSlidingImages.self , forCellWithReuseIdentifier: CellSlidingImages.getID() )
        
        return c
    }()
    
    
    
    public init (startFrame : CGRect, startImage : UIImage , imageURL : String ) {
        super.init(nibName: nil , bundle: nil )
        self.listImagesURL = [ imageURL ]
        self.pageIndex = 0
        self.startFrame = startFrame
        self.startImage = startImage
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public init ( imageURL : String) {
        super.init(nibName: nil , bundle: nil )
        self.listImagesURL = [ imageURL ]
        self.pageIndex = 0
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public init (startFrame : CGRect, startImage : UIImage , listImagesURL : [ Any ] , index : Int = 0 ) {
        super.init(nibName: nil , bundle: nil )
        self.listImagesURL =  listImagesURL
        self.pageIndex = ( index < self.listImagesURL.count) ? index : ( self.listImagesURL.count - 1 )
        self.startFrame = startFrame
        self.startImage = startImage
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public init ( listImagesURL : [ Any ] , index : Int = 0 ) {
        super.init(nibName: nil , bundle: nil )
        self.listImagesURL = listImagesURL
        self.pageIndex = ( index < self.listImagesURL.count) ? index : ( self.listImagesURL.count - 1 )
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public init (startFrame : CGRect , startImage : UIImage ) {
        super.init(nibName: nil , bundle: nil )
        self.startFrame = startFrame
        self.startImage = startImage
        self.listImagesURL = [ startImage ]
        self.pageIndex = 0
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public init ( image : UIImage) {
        super.init(nibName: nil , bundle: nil )
        self.startImage = image
        self.listImagesURL = [image]
        self.pageIndex = 0
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self , action: #selector(handelPanGestureRecognizer(_:)) )
        self.view.addGestureRecognizer(self.panGestureRecognizer)
        
        
        
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        
        collectionView.scrollToItem(at: IndexPath(row: pageIndex , section: 0), at: .centeredHorizontally , animated: true )
        
    }
    
    
    private func addViews () {
        self.view.addSubview(collectionView)
        //   self.view.addSubview(closeButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: 0).isActive = true
        
        //        closeButton.translatesAutoresizingMaskIntoConstraints = false
        //        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 16).isActive = true
        //        closeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor , constant: 16 ).isActive = true
        //        closeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    
    
    private func getCurrentCell() -> CellSlidingImages? {
        let indexPath = IndexPath(row: pageIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CellSlidingImages else {
            return nil
        }
        return cell
    }
    
    
    @objc private func handelPanGestureRecognizer (_ gestureRecognizer : UIPanGestureRecognizer ) {
        guard let cell = getCurrentCell() else {
            return
        }
        if cell.scrollView.zoomScale  > 1.0 {
            return
        }
        
        if gestureRecognizer.state == .began{
            self.startPanGesture()
            // originPosition = gestureRecognizer.view!.center.y
            
         //   let velocity = gestureRecognizer.velocity(in: cell.contentView )
            //            if (velocity.x > 0 || velocity.x < 0 ) && ( velocity.y == 0 )  {
            //                gestureHorizontal = true
            //                allowScrollView()
            //            }else {
            //                disAllowScrollView()
            //                gestureHorizontal = false
            //            }
        }else if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: cell.contentView)
            
            // if !gestureHorizontal {
            let animate = cell.startWithAnimation
            let count = listImagesURL.count
            
            if animate && count == 1 {
                cell.imageView.center = CGPoint(x: cell.imageView.center.x + translation.x , y: cell.imageView.center.y + translation.y)
                let absolute = 1 - abs((cell.contentView.center.y - (cell.imageView.center.y)) / 800)
                cell.scrollView.backgroundColor = UIColor.black.withAlphaComponent(absolute )
                gestureRecognizer.setTranslation(CGPoint.zero, in: cell.contentView)
            }else {
                cell.imageView.center = CGPoint(x: cell.imageView.center.x , y: cell.imageView.center.y + translation.y)
                let absolute = 1 - abs((cell.contentView.center.y - (cell.imageView.center.y)) / 800)
                cell.scrollView.backgroundColor = UIColor.black.withAlphaComponent(absolute )
                gestureRecognizer.setTranslation(CGPoint.zero, in: cell.contentView)
            }
            
        }else if gestureRecognizer.state == .ended{
            
            let animate = cell.startWithAnimation
            let count = listImagesURL.count
            
            if animate && count == 1 {
                
                if ( abs(self.view.center.y - (cell.imageView.center.y)) > CGFloat(150) ){
                    cell.animateOut()
                    
                }else{
                    self.returnImageToCenter()
                    UIView.animate(withDuration: 0.3) {
                        cell.imageView.frame = cell.originalFrameForGeneratedSHowImage!
                        cell.scrollView.backgroundColor = UIColor.black.withAlphaComponent(1)
                        
                    }
                }
                
            }else {
                
                if ( cell.contentView.center.y - (cell.imageView.center.y) > CGFloat(150) ){
                    cell.animateOutTop()
                }else if  ( cell.contentView.center.y - (cell.imageView.center.y) < CGFloat(-150) ){
                    cell.animateOutBottom()
                }else{
                    self.returnImageToCenter()
                    UIView.animate(withDuration: 0.3) {
                        cell.imageView.frame = cell.originalFrameForGeneratedSHowImage!
                        cell.scrollView.backgroundColor = UIColor.black.withAlphaComponent(1)
                        
                    }
                }
                
            }
            
            
        }
        
    }
    
    open func startPanGesture() {
        
    }
    
    open func returnImageToCenter() {
        
    }
    
    open func singleTapped() {
        
    }
    
    
}
extension LeonImages : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , IsScrollEnableDelegate {
    
    func allowScrollView() {
        collectionView.isScrollEnabled = true
    }
    
    func disAllowScrollView() {
        collectionView.isScrollEnabled = false
    }
    
    open func dismissLeon() {
        self.finishVC?()
        self.dismiss(animated: true)
    }
    
   
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        
        if let cell = cell as? CellSlidingImages {
            cell.scrollView.zoomScale = 1.0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImagesURL.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellSlidingImages.getID() , for: indexPath) as! CellSlidingImages
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let imageList = listImagesURL[indexPath.row]
        
        
        if pageIndex == indexPath.row {
            cell.startFrame = self.startFrame
            cell.startImage = self.startImage
        }else {
            cell.startFrame = nil
            cell.startImage = nil
            cell.imageView.image = nil
        }
        
        //    cell.imageURL = imageList
        cell.loadImage(image: imageList)
        cell.errorMessage = self.errorMessage
        cell.tapToReload = self.tapToReload
        cell.addViews()
        cell.delegate = self
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height )
    }
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffSetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.width
        let newPageIndex = Int(round(contentOffSetX / scrollViewWidth))
        if pageIndex != newPageIndex {
            pageIndex = newPageIndex
        }
    }
}

