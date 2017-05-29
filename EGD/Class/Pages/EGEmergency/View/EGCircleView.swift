//
//  EGCircleView.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit

protocol clickCycleImageDelegate {
    
    func didCycleImageIndexPth(indexpath:IndexPath)
}

private let  EGCircleCellID = "EGCircleCell"

class EGCircleView: UIView {
    
    fileprivate lazy var topCollectionView : UICollectionView = {[unowned self] in
        
        let layout  =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0       //最小行间距
        layout.minimumInteritemSpacing = 0  //最小列间距
        layout.scrollDirection = .horizontal
        
        let topCollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.isPagingEnabled = true
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.register(EGCircleCollectionViewCell.self, forCellWithReuseIdentifier: EGCircleCellID)
        layout.itemSize = topCollectionView.bounds.size
        
        return topCollectionView
        }()
    
    
    fileprivate lazy var pageControl :UIPageControl = {[unowned self] in
        
        let pageControl = UIPageControl(frame: CGRect(x: self.frame.size.width - 100 - 10, y: self.frame.size.height - 40, width: 100, height: 40))
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.yellow
        
        return pageControl
        }()
    
    var timer :Timer?
    var delegate :clickCycleImageDelegate?
    
    var dataArray :[EGBaseModel]?{
        
        didSet{
            topCollectionView.reloadData()
            pageControl.numberOfPages = dataArray?.count ?? 0
            let indexPath = IndexPath(item: (dataArray?.count ?? 0)*100, section: 0)
            topCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            removeCycleTimer()
            addCircleTimer()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topCollectionView)
        addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EGCircleView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return (dataArray?.count)!*1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EGCircleCellID, for: indexPath) as! EGCircleCollectionViewCell
        cell.model = dataArray?[indexPath.row % (dataArray?.count)!]
        
        print("\([indexPath.row % (dataArray?.count)!])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didCycleImageIndexPth(indexpath: indexPath)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5 //超过屏幕一般就偏移
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (dataArray?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCircleTimer()
    }
    
}

extension EGCircleView{
    
    //打开定时器
    fileprivate func addCircleTimer() {
        timer  =  Timer.init(timeInterval: 2.0, target: self, selector: #selector(scrollNext), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    func scrollNext() {
        topCollectionView.setContentOffset(CGPoint(x: topCollectionView.contentOffset.x + topCollectionView.bounds.width, y: topCollectionView.bounds.origin.y), animated: true)
    }
    //移除定时器
    fileprivate func removeCycleTimer(){
        timer?.invalidate()
        timer = nil
    }
}




