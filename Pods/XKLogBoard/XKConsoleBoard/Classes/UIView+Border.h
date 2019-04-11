//
//  UIView+Border.h
//  Erp4iOS
//
//  Created by rztime on 2017/11/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@class RZBorderSite;

typedef NS_OPTIONS(NSUInteger, rzBorderSitePlace) {
	rzBorderSitePlaceNone    	= 0,
	rzBorderSitePlaceTop		= 1 << 0,
	rzBorderSitePlaceLeft 		= 1 << 1,
	rzBorderSitePlaceBottom 	= 1 << 2,
	rzBorderSitePlaceRight 		= 1 << 3
};
// 须依赖 Masonry
@interface UIView (Border)

/**
 设置显示哪一个边界线

 @param site <#site description#>
 */
- (void)showBorderSite:(rzBorderSitePlace)site;

/**
 上边框线，可设置，左、右、上边距、下边距设置无效
 */
@property (nonatomic, strong) RZBorderSite * topBorder;
/**
 左边框线，可设置，左、上、下边距、右边距设置无效
 */
@property (nonatomic, strong) RZBorderSite * leftBorder;
/**
 下边框线，可设置，左、右、下边距、上边距设置无效
 */
@property (nonatomic, strong) RZBorderSite * bottomBorder;
/**
 右边框线，可设置，上、下、右边距、左边距设置无效
 */
@property (nonatomic, strong) RZBorderSite * rightBorder;

@end


@interface RZBorderSite : NSObject

@property (nonatomic, assign) BOOL sizeWithHeight;

/**
 默认灰色 RGB(204, 204, 204) 边框线
 */
@property (nonatomic, strong) UIView *borderLine;

/**
 边框的size（粗细） 默认 1
 */
@property (nonatomic, assign) CGFloat borderSize;
/**
 上边距 default = 0
 */
@property (nonatomic, assign) CGFloat topMargin;
/**
 左边距
 default = 0
 */
@property (nonatomic, assign) CGFloat leftMargin;
/**
 下边距
 default = 0
 */
@property (nonatomic, assign) CGFloat bottomMargin;
/**
 右边距
 default = 0
 */
@property (nonatomic, assign) CGFloat rightMargin;

@end
