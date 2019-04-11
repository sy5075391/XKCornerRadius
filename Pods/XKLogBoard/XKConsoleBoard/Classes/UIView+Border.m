//
//  UIView+Border.m
//  Erp4iOS
//
//  Created by rztime on 2017/11/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIView+Border.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

@implementation RZBorderSite

- (instancetype)init {
	if (self = [super init]) {
		_topMargin = 0;
		_leftMargin = 0;
		_bottomMargin = 0;
		_rightMargin = 0;
		_borderSize = 1;
	}
	return self;
}

- (UIView *)borderLine {
	if (!_borderLine) {
		_borderLine = [[UIView alloc]init];
		_borderLine.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
	}
	return _borderLine;
}

- (void)setTopMargin:(CGFloat)topMargin {
	_topMargin = topMargin;
	if (!_borderLine) {
		return;
	}
	UIView *superView = [_borderLine superview];
	if (!superView) {
		return ;
	}
	[_borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(superView).offset(self.topMargin);
	}];
}

- (void)setLeftMargin:(CGFloat)leftMargin {
	_leftMargin = leftMargin;
	
	if (!_borderLine) {
		return;
	}
	UIView *superView = [_borderLine superview];
	if (!superView) {
		return ;
	}
	[_borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(superView).offset(self.leftMargin);
	}];
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
	_bottomMargin = bottomMargin;
    
	if (!_borderLine) {
		return;
	}
	UIView *superView = [_borderLine superview];
	if (!superView) {
		return ;
	}
	[_borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(superView).offset(-self.bottomMargin);
	}];
}

- (void)setRightMargin:(CGFloat)rightMargin {
	_rightMargin = rightMargin;
    
	if (!_borderLine) {
		return;
	}
	UIView *superView = [_borderLine superview];
	if (!superView) {
		return ;
	}
	[_borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(superView).offset(-self.rightMargin);
	}];
}

- (void)setBorderSize:(CGFloat)borderSize {
    _borderSize = borderSize;
    
    if (!_borderLine) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [_borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.sizeWithHeight) {
            make.height.equalTo(@(weakSelf.borderSize));
        } else {
            make.width.equalTo(@(weakSelf.borderSize));
        }
    }];
}

@end

@implementation UIView (Border)
@dynamic topBorder, leftBorder, bottomBorder, rightBorder;

- (void)setTopBorder:(RZBorderSite *)topBorder {
	objc_setAssociatedObject(self, @"rzTopBorder", topBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RZBorderSite *)topBorder {
	return objc_getAssociatedObject(self, @"rzTopBorder");
}
- (void)setLeftBorder:(RZBorderSite *)leftBorder {
	objc_setAssociatedObject(self, @"rzLeftBorder", leftBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RZBorderSite *)leftBorder {
	return objc_getAssociatedObject(self, @"rzLeftBorder");
}

- (void)setBottomBorder:(RZBorderSite *)bottomBorder {
	objc_setAssociatedObject(self, @"rzBottomBorder", bottomBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RZBorderSite *)bottomBorder {
	return objc_getAssociatedObject(self, @"rzBottomBorder");
}

- (void)setRightBorder:(RZBorderSite *)rightBorder {
	objc_setAssociatedObject(self, @"rzRightBorder", rightBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RZBorderSite *)rightBorder {
	return objc_getAssociatedObject(self, @"rzRightBorder");
}

/**
 设置显示哪一个边界线
 
 @param site <#site description#>
 */
- (void)showBorderSite:(rzBorderSitePlace)site {
	if (site == rzBorderSitePlaceNone) {
		// 不显示所有的
		if (self.topBorder) {
			self.topBorder.borderLine.hidden = YES;
		}
		if (self.leftBorder) {
			self.leftBorder.borderLine.hidden = YES;
		}
		if (self.bottomBorder) {
			self.bottomBorder.borderLine.hidden = YES;
		}
		if (self.rightBorder) {
			self.rightBorder.borderLine.hidden = YES;
		}
		return ;
	}
	if (site & rzBorderSitePlaceTop) {
		// 显示上边界线
		if (!self.topBorder) {
			RZBorderSite *border = [[RZBorderSite alloc]init];
			[self addSubview:border.borderLine];
            border.sizeWithHeight = YES;
			[border.borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self).offset(border.topMargin);
				make.left.equalTo(self).offset(border.leftMargin);
				make.right.equalTo(self).offset(-border.rightMargin);
				make.height.equalTo(@(border.borderSize));
			}];
			self.topBorder = border;
		}
		self.topBorder.borderLine.hidden = NO;
	} else {
		self.topBorder.borderLine.hidden = YES;
	}
	if (site & rzBorderSitePlaceLeft) {
		if (!self.leftBorder) {
			// 显示左边界线
			RZBorderSite *border = [[RZBorderSite alloc]init];
			[self addSubview:border.borderLine];
			border.sizeWithHeight = NO;
			[border.borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self).offset(border.topMargin);
				make.bottom.equalTo(self).offset(-border.bottomMargin);
				make.left.equalTo(self).offset(border.leftMargin);
				make.width.equalTo(@(border.borderSize));
			}];
			self.leftBorder = border;
		}
		self.leftBorder.borderLine.hidden = NO;
	} else {
		self.leftBorder.borderLine.hidden = YES;
	}
	
	if (site & rzBorderSitePlaceBottom) {
		// 显示下边界线
		if (!self.bottomBorder) {
			RZBorderSite *border = [[RZBorderSite alloc]init];
			[self addSubview:border.borderLine];
			border.sizeWithHeight = YES;
			[border.borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(self).offset(-border.bottomMargin);
				make.left.equalTo(self).offset(border.leftMargin);
				make.right.equalTo(self).offset(-border.rightMargin);
				make.height.equalTo(@(border.borderSize));
			}];
			self.bottomBorder = border;
		}
		self.bottomBorder.borderLine.hidden = NO;
	} else {
		self.bottomBorder.borderLine.hidden = YES;
	}
	if (site & rzBorderSitePlaceRight) {
		// 显示右边界线
		if (!self.rightBorder) {
			RZBorderSite *border = [[RZBorderSite alloc]init];
			[self addSubview:border.borderLine];
			border.sizeWithHeight = NO;
			[border.borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self).offset(border.topMargin);
				make.bottom.equalTo(self).offset(-border.bottomMargin);
				make.right.equalTo(self).offset(-border.rightMargin);
				make.width.equalTo(@(border.borderSize));
			}];
			self.rightBorder = border;
		}
		self.rightBorder.borderLine.hidden = NO;
	} else {
		self.rightBorder.borderLine.hidden = YES;
	}
}

@end
