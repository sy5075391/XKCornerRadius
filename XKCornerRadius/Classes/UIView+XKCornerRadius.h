//
//  UITableViewCell+XKCornerRadius.h
//  XKSquare
//
//  Created by Jamesholy on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

// 切圆角工具 mask

#import <UIKit/UIKit.h>

#define XKCornerClipTypeTopBoth (XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight)
#define XKCornerClipTypeBottomBoth (XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight)

typedef NS_OPTIONS (NSUInteger, XKCornerClipType) {
    XKCornerClipTypeNone = 0,  //不切
    XKCornerClipTypeTopLeft     = 1 << 0,
    XKCornerClipTypeTopRight    = 1 << 1,
    XKCornerClipTypeBottomLeft  = 1 << 2,
    XKCornerClipTypeBottomRight = 1 << 3,
    XKCornerClipTypeAllCorners  = 1 << 4
};

@interface UIView (XKCornerRadius)
/**针对这个view 切圆角工具是否可用  defualt NO  tip：开启后后清除圆角使用 xk_clipType =XKCornerClipTypeNone */
@property(nonatomic, assign) BOOL xk_openClip;
/**圆角大小 -- tip：切圆角 XKCornerClipType*/
@property(nonatomic, assign) CGFloat xk_radius;
/**圆角类型 -- tip：切圆角 XKCornerClipType*/
@property(nonatomic, assign) XKCornerClipType xk_clipType;

/**此分类重写view的layoutsubviews，进行切割圆角
    当视图显示出来后，如果视图frame没有变化或者没有添加子视图等，不触发layoutsubviews方法，
    所以后续再进行的圆角设置会不起作用（复用cell除外，复用时会再次调用layoutsubviews），
    此时为了圆角生效可调用forceClip;
 */
- (void)xk_forceClip;

@end
