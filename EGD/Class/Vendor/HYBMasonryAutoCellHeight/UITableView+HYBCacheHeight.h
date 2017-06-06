//
//  UITableViewCell+HYBMasonryAutoCellHeight.h
//  WithYou
//
//  Created by TSM on 17/4/26.
//  Copyright © 2017年 捷酷有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  基于Masonry自动布局实现的自动计算cell的行高扩展
 *
 */
@interface UITableView (HYBCacheHeight)

/**
 *	
 *
 *	用于缓存cell的行高
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hyb_cacheCellHeightDict;

/**
 *
 *	用于获取或者添加计算行高的cell，因为理论上只有一个cell用来计算行高，以降低消耗
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hyb_reuseCells;

@end
