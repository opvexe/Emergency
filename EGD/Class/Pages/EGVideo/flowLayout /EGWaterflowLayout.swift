//
//  EGWaterflowLayout.swift
//  EGD
//
//  Created by jieku on 2017/6/9.
//
//

import UIKit
//代理事件
protocol EGWaterflowLayoutDelegate: NSObjectProtocol{
    func waterflowLayout(waterflowLayout: EGWaterflowLayout, heightForItemAtIndex: Int, itemWidth: CGFloat) -> CGFloat
    func columnCountInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> NSInteger
    func columnMarginInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> CGFloat
    func rowMarginInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> CGFloat
    func edgeInsetsInWaterflowLayout(waterflowLayout: EGWaterflowLayout) -> UIEdgeInsets
}
fileprivate let  XMGDefaultColumnCount = 3/** 默认的列数 */
fileprivate let  XMGDefaultColumnMargin = 3 /** 每一列之间的间距 */
fileprivate let  XMGDefaultRowMargin = 3 /** 每一行之间的间距 */
fileprivate let  XMGDefaultEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10) /** 边缘间距 */
class EGWaterflowLayout: UICollectionViewLayout {
    
    fileprivate var rowMargin: CGFloat {
        guard ((delegate?.rowMarginInWaterflowLayout(waterflowLayout: self)) != nil) else {
            return  CGFloat(XMGDefaultRowMargin)
        }
        return CGFloat((delegate?.rowMarginInWaterflowLayout(waterflowLayout: self))!)
    }
    fileprivate var columnMargin: CGFloat {
        
        guard ((delegate?.columnMarginInWaterflowLayout(waterflowLayout: self)) != nil) else {
            return CGFloat(XMGDefaultColumnMargin)
        }
        return (delegate?.columnMarginInWaterflowLayout(waterflowLayout: self))!
        
    }
    fileprivate var columnCount: NSInteger  {
        
        guard ((delegate?.columnCountInWaterflowLayout(waterflowLayout: self)) != nil) else {
            return  XMGDefaultColumnCount
        }
        return (delegate?.columnCountInWaterflowLayout(waterflowLayout: self))!
        
    }
    fileprivate var sectionInsets: UIEdgeInsets {
        
        guard ((delegate?.edgeInsetsInWaterflowLayout(waterflowLayout: self)) != nil) else {
            return  XMGDefaultEdgeInsets
        }
        return (delegate?.edgeInsetsInWaterflowLayout(waterflowLayout: self))!
        
    }
    //MARK : 代理
    weak var delegate :EGWaterflowLayoutDelegate?
    //MARK : 每行对应的高度
    fileprivate var columnHeights: [Int: CGFloat]                  = [Int: CGFloat]()
    fileprivate var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0.0
    //MARK : 初始化
    override func prepare() {
        super.prepare()
        guard collectionView != nil else {
            return
        }
        contentHeight = 0.0   //先初始化内容的高度为0
        columnHeights.removeAll()         // 清除以前计算的所有高度
        for i in 0..<columnCount {
            columnHeights[i] = sectionInsets.top
        }
        // 清除之前所有的布局属性
        attributes.removeAll()
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<itemCount {
            if let att = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0)) {
                attributes.append(att)
            }
        }
    }
    
    //MARK :决定cell的排布
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let collectionView = collectionView {
            //根据indexPath获取item的attributes
            let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            //获取collectionView的宽度
            let width = collectionView.frame.width
            let W = (width - sectionInsets.left - sectionInsets.right - (CGFloat(columnCount) - 1)*columnMargin)
            let itemWidth  = W/(CGFloat)(columnCount)
            let H = delegate?.waterflowLayout(waterflowLayout:self, heightForItemAtIndex:indexPath.item, itemWidth:itemWidth)
            //找出来最短后 就把下一个cell 添加到低下
            var  destColumn = 0
            var minColumnHeight = columnHeights[0]
            for i in 1..<columnCount {
                // 取得第i列的高度
                let columnHeight = columnHeights[i]
                if (CGFloat)(minColumnHeight!) > (CGFloat)(columnHeight!) {
                    minColumnHeight = columnHeight
                    destColumn = i
                }
            }
            
            let  X = sectionInsets.left + (CGFloat)(destColumn) * (itemWidth + self.columnMargin)
            var  Y  = (CGFloat)(minColumnHeight!)
            
            if Y != sectionInsets.top {
                Y += rowMargin
            }
            attrs.frame = CGRect.init(x: X, y: Y, width: itemWidth, height: H!)
            // 更新最短那列的高度
            columnHeights[destColumn] = attrs.frame.maxY
            let  columnHeightV = columnHeights[destColumn]
            //找出最高的高度
            if (self.contentHeight < columnHeightV!) {
                self.contentHeight = columnHeightV!
            }
            return attrs
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize{
        
        return CGSize.init(width: 0, height: contentHeight + sectionInsets.bottom)
    }
}
