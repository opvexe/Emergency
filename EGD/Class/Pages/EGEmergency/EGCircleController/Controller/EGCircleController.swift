//
//  EGCircleController.swift
//  EGD
//
//  Created by jieku on 2017/5/30.
//
//

import UIKit

private let EGCircleCollectionCellID = "EGCircleCollectionCellID"
class EGCircleController: UIViewController {
    
    
    fileprivate lazy var circlrCollectionView : UICollectionView = {[unowned self] in
        
        let layout  =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0       //最小行间距
        layout.minimumInteritemSpacing = 0  //最小列间距
        layout.scrollDirection = .horizontal
        
        let circlrCollectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        circlrCollectionView.delegate = self
        circlrCollectionView.dataSource = self
        circlrCollectionView.isPagingEnabled = true
        circlrCollectionView.showsHorizontalScrollIndicator = false
        circlrCollectionView.register(EGTapCircleCollectionViewCell.self, forCellWithReuseIdentifier: EGCircleCollectionCellID)
        layout.itemSize = circlrCollectionView.bounds.size
        
        return circlrCollectionView
        }()

   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.white
//        
//        imageShow = UIImageView.init()
//        imageShow?.isUserInteractionEnabled = true
//        imageShow?.image = UIImage(named:(picURL)!)
//     
//        let photoView = EGPhotoPreviewer()
//        photoView.preview(fromImageView: imageShow!, container: self.view)
      view.addSubview(circlrCollectionView)
        
    }
   
}

extension EGCircleController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EGCircleCollectionCellID, for: indexPath) as! EGTapCircleCollectionViewCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5 //超过屏幕一般就偏移
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
}




