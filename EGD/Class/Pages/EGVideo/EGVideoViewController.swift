//
//  EGVideoViewController.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit
import MJRefresh
import MJExtension

private let VideoCollectionCellID = "VideoCollectionCellID"
class EGVideoViewController: UIViewController {
    
    fileprivate lazy var VideoCollectionView : UICollectionView = {[unowned self] in
        let layout  =  EGWaterflowLayout()
        layout.delegate = self
        let VideoCollectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        VideoCollectionView.dataSource = self
        VideoCollectionView.backgroundColor = UIColor.white
        VideoCollectionView.register(EGVideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionCellID)
        return VideoCollectionView
        }()
    fileprivate var shopDataSouceArray = NSMutableArray.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(VideoCollectionView)
        
        
        setupRefresh()
    }
}

extension EGVideoViewController {
    
    fileprivate func setupRefresh() {

        VideoCollectionView.mj_header  = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(EGVideoViewController.loadNewShop))
        VideoCollectionView.mj_header.beginRefreshing()
        
         VideoCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(EGVideoViewController.loadMoreShop))
        
    }
    @objc fileprivate  func loadNewShop() {
         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let shopArray = EGShopModel.mj_objectArray(withFilename: "1.plist")
            self.shopDataSouceArray.removeAllObjects()
            self.shopDataSouceArray.addObjects(from: shopArray as! [Any])
            self.VideoCollectionView.reloadData()
            self.VideoCollectionView.mj_header.endRefreshing()
        })
    }
    
    @objc fileprivate func loadMoreShop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
           let shopArray = EGShopModel.mj_objectArray(withFilename: "1.plist")
            self.shopDataSouceArray.addObjects(from: shopArray as! [Any])
            self.VideoCollectionView.reloadData()
            self.VideoCollectionView.mj_footer.endRefreshing()
        })
    }
}

extension EGVideoViewController: UICollectionViewDataSource, EGWaterflowLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopDataSouceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionCellID, for: indexPath) as! EGVideoCollectionViewCell
        
        cell.model = self.shopDataSouceArray[indexPath.row] as? EGShopModel
        return cell
    }
    
    //MARK : EGWaterflowLayoutDelegate
    func waterflowLayout(waterflowLayout: EGWaterflowLayout, heightForItemAtIndex: Int, itemWidth: CGFloat) -> CGFloat {
        //返回每个cell的高度
        let shopModel = self.shopDataSouceArray[heightForItemAtIndex] as? EGShopModel
        return itemWidth*(shopModel?.h)!/(shopModel?.w)!
    }
    //有多少列
    func columnCountInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> NSInteger {
        guard self.shopDataSouceArray.count <= 50 else {
            return 3
        }
        return 2
    }
    
    func columnMarginInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> CGFloat {
        return 3
    }
    
    //每行的最小距离
    func rowMarginInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> CGFloat {
        return 10
    }
    //内边距
    func edgeInsetsInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 5, bottom: 50, right: 5)
    }
}
