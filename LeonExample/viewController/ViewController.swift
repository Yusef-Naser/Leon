//
//  ViewController.swift
//  LeonExample
//
//  Created by yusef naser on 11/9/19.
//  Copyright © 2019 yusef naser. All rights reserved.
//

import UIKit
import Leon

class ViewController: UIViewController {
    
    
    let url1 = "https://image.tmdb.org/t/p/w500/o4I5sHdjzs29hBWzHtS2MKD3JsM.jpg"
    let url2 = "https://image.tmdb.org/t/p/w500/2CAL2433ZeIihfX1Hb2139CX0pW.jpg"
    let url3 = "https://image.tmdb.org/t/p/w500/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg"
    let url4 = "https://image.tmdb.org/t/p/w500/rPdtLWNsZmAtoZl9PK7S2wE3qiS.jpg"
    let url5 = "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg"
    let url6 = "https://image.tmdb.org/t/p/w500/yPisjyLweCl1tbgwgtzBCNCBle.jpg"
    let url7 = "https://image.tmdb.org/t/p/w500/xq1Ugd62d23K2knRUx6xxuALTZB.jpg"
    let url8 = "https://image.tmdb.org/t/p/w500/bVq65huQ8vHDd1a4Z37QtuyEvpA.jpg"
    let url9 = "https://image.tmdb.org/t/p/w500/oRvMaJOmapypFUcQqpgHMZA6qL9.jpg"
    let url10 = "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg"
    let url11 = "https://image.tmdb.org/t/p/w500/f7DImXDebOs148U4uPjI61iDvaK.jpg"
    
    var arrayImages : [String] = []
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayImages = [  url3 , url4 , url5 , url6 , url7 , url8 , url9 , url10  ]
        
        // Do any additional setup after loading the view.
        firstImageView.isUserInteractionEnabled = true
        firstImageView.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(openFirstImageZooming)))
        
        firstImageView.dowloadFromServer(link: url3 )
        
        
        secondImageView.isUserInteractionEnabled = true
        secondImageView.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(openSecondImageZooming)))
        
        //     imageView.imageFromServerURL(urlString: "https://image.tmdb.org/t/p/w500/o4I5sHdjzs29hBWzHtS2MKD3JsM.jpg")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        return .default
    }
    
    @objc private func openFirstImageZooming() {
        
        let point = firstImageView.convert(self.firstImageView.bounds.origin, to: view  )
        let size = CGSize(width: firstImageView.frame.width , height: firstImageView.frame.height)

        
        // 1- first init
        //  let vc = LeonImages(image: firstImageView.image!)
        
        //2- second parm
        //   let vc = LeonImages(imageURL: url6 )
        
        // 3- third parm
        let vc = LeonImages(listImagesURL: [  url4 , url5 , url6 , url7 , url8 , url9 , url10 , url11 ] , index : 2 )
        
        // 4- fourth parm
        //  let vc = LeonImages(listImagesURL: [ url1 , url2 , url3 , url4 , url5 , url6 , url7 , url8 , url9 , url10 , url11 ] )
        
        // 4.1 - 4.1 parm
        //  let vc = LeonImages(startFrame:CGRect(origin: point , size: size ) , startImage: firstImageView.image!, imageURL: url6 )
        
        //5- 5 parm
        //   let vc = LeonImages(startFrame: CGRect(origin: point , size: size ) , startImage: firstImageView.image! )
        
        // 6- 6 parm
        //     let vc = LeonImages(startFrame: CGRect(origin: point , size: size ) , startImage: firstImageView.image!, listImagesURL: [ url1 , url2 , url3 , url4 , url5 , url6 , url7 , url8 , url9 , url10 , url11 ] , index : 2 )
        
        
        // 6.1- 6 parm
        //      let vc = LeonImages(startFrame: CGRect(origin: point , size: size ) , startImage: firstImageView.image!, listImagesURL: [ url1 , url2 , url3 , url4 , url5 , url6 , url7 , url8 , url9 , url10 , url11 ] )
        
        
        self.present( vc , animated: true )
        
        
    }
    
    @objc private func openSecondImageZooming() {
       
        let vc = CustomLeonImages(image: self.secondImageView.image! )
        self.present( vc , animated: true )
        
    }
    
    
    
}

extension UIImageView {
    
    private func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode ) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
    
    
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            CellCollectionImages.getID() , for: indexPath ) as! CellCollectionImages
        cell.imageCell.image = nil
        cell.imageCell.dowloadFromServer(link: arrayImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let attributes = collectionView.layoutAttributesForItem(at: indexPath) , let cell = collectionView.cellForItem(at: indexPath) as? CellCollectionImages {
            
            
            let realFrame = collectionView .convert(attributes.frame , to: collectionView.superview)
            
            
            let vc = CustomLeonImages(startFrame: realFrame , startImage: cell.imageCell.image ?? UIImage(), listImagesURL: arrayImages , index: indexPath.row )
            self.present(vc , animated: true )
        }
        
    }
    
    
    
    
}
