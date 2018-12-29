//
//  UITableViewCell+XKCornerRadius.m
//  XKSquare
//
//  Created by Jamesholy on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIView+XKCornerRadius.h"
#import <objc/runtime.h>

@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *maskLayer;
/**圆角状态是否变化*/
@property(nonatomic, assign) BOOL radiusStatusChange;
@end

@implementation UIView (XKCornerRadius)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sy_layoutSubviews);
        [self xk_swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
    });
}

+ (void)xk_swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)xk_forceClip {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)sy_layoutSubviews {
    [self sy_layoutSubviews];
    if (self.xk_openClip) {
//        if (self.radiusStatusChange == NO) return;
        self.radiusStatusChange = NO;
        if (self.xk_clipType == XKCornerClipTypeNone) {
            self.layer.mask = nil;
        } else {
            UIRectCorner rectCorner = [self getRectCorner];
            if (self.maskLayer == nil) {
                self.maskLayer = [[CAShapeLayer alloc] init];
            }
            
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.xk_radius, self.xk_radius)];
            self.maskLayer.frame = self.bounds;
            self.maskLayer.path = maskPath.CGPath;
            self.layer.mask = self.maskLayer;
        }
    }
}

- (UIRectCorner)getRectCorner {
    UIRectCorner rectCorner = 0;
    if (self.xk_clipType & XKCornerClipTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.xk_clipType & XKCornerClipTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.xk_clipType & XKCornerClipTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.xk_clipType & XKCornerClipTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.xk_clipType & XKCornerClipTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey = "cornerRadius_openKey";
- (void)setXk_openClip:(BOOL)xk_openClip {
    objc_setAssociatedObject(self, cornerRadius_openKey, @(xk_openClip), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xk_openClip {
    return [objc_getAssociatedObject(self, cornerRadius_openKey) boolValue];
}

static const char *cornerRadius_radiusKey = "XKCornerRadius_radius";
- (void)setXk_radius:(CGFloat)xk_radius {
    if (xk_radius == self.xk_radius) {
    } else {
        self.radiusStatusChange = YES;
    }
     objc_setAssociatedObject(self, cornerRadius_radiusKey, @(xk_radius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)xk_radius {
      return [objc_getAssociatedObject(self, cornerRadius_radiusKey) floatValue];
}

static const char *cornerRadius_TypeKey = "cornerRadius_TypeKey";
- (void)setXk_clipType:(XKCornerClipType)xk_clipType {
    if (xk_clipType == self.xk_clipType) {
    } else {
        self.radiusStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey, @(xk_clipType), OBJC_ASSOCIATION_RETAIN);
}

- (XKCornerClipType)xk_clipType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey) unsignedIntegerValue];
}

static const char *cornerRadius_maskLayerKey = "cornerRadius_maskLayerKey";
- (void)setMaskLayer:(CAShapeLayer *)maskLayer {
    objc_setAssociatedObject(self, cornerRadius_maskLayerKey, maskLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)maskLayer {
    return objc_getAssociatedObject(self, cornerRadius_maskLayerKey);
}

static const char *cornerRadius_StatusKey = "cornerRadius_StatusKey";
- (void)setRadiusStatusChange:(BOOL)radiusStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey, @(radiusStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)radiusStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey) boolValue];
}

@end
