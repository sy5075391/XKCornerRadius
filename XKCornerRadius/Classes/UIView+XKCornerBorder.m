//
//  UIView+XKCornerBorder.m
//  XKSquare
//
//  Created by Jamesholy on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIView+XKCornerBorder.h"
#import <objc/runtime.h>
@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *subBorderLayer;
/**边框状态是否变化*/
@property(nonatomic, assign) BOOL borderStatusChange;
@end

@implementation UIView (XKCornerBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sy_borderlayoutSubviews);
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

- (void)xk_forceReLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)sy_borderlayoutSubviews {
    [self sy_borderlayoutSubviews];
    if (self.xk_openBorder) {
//        if (self.borderStatusChange == NO) return;
        self.borderStatusChange = NO;
        if (self.xk_openBorder == XKBorderTypeNone) {
            [self.subBorderLayer removeFromSuperlayer];
        } else {
            UIRectCorner rectCorner = [self getRectCornerForBorder];
            if (self.subBorderLayer == nil) {
                self.subBorderLayer = [[CAShapeLayer alloc] init];
            }
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width -  self.xk_borderWidth, self.frame.size.height - self.xk_borderWidth) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.xk_borderRadius, self.xk_borderRadius)];
            self.subBorderLayer.frame = CGRectMake(self.xk_borderWidth / 2, self.xk_borderWidth / 2,self.frame.size.width - self.xk_borderWidth,self.frame.size.height - self.xk_borderWidth);
            self.subBorderLayer.path = maskPath.CGPath;
            self.subBorderLayer.fillColor = self.xk_borderFillColor.CGColor;
            self.subBorderLayer.strokeColor = self.xk_borderColor.CGColor;
            self.subBorderLayer.lineWidth = self.xk_borderWidth;
            
            if (!self.subBorderLayer.superlayer) {
                [self.layer addSublayer:self.subBorderLayer];
            }
        }
    }
}

- (UIRectCorner)getRectCornerForBorder {
    UIRectCorner rectCorner = 0;
    if (self.xk_borderType & XKBorderTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.xk_borderType & XKBorderTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.xk_borderType & XKBorderTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.xk_borderType & XKBorderTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.xk_borderType & XKBorderTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey_border = "cornerRadius_openKey_border";
- (void)setXk_openBorder:(BOOL)xk_openBorder {
    objc_setAssociatedObject(self, cornerRadius_openKey_border, @(xk_openBorder), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xk_openBorder {
    return [objc_getAssociatedObject(self, cornerRadius_openKey_border) boolValue];
}

static const char *cornerRadius_radiusKey_border = "cornerRadius_radiusKey_border";
- (void)setXk_borderRadius:(CGFloat)xk_borderRadius {
    if (xk_borderRadius == self.xk_borderRadius) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_radiusKey_border, @(xk_borderRadius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)xk_borderRadius {
    return [objc_getAssociatedObject(self, cornerRadius_radiusKey_border) floatValue];
}

static const char *cornerRadiusWidth_radiusKey_border = "cornerRadiusWidth_radiusKey_border";
- (void)setXk_borderWidth:(CGFloat)xk_borderWidth{
    if (xk_borderWidth == self.xk_borderWidth) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusWidth_radiusKey_border, @(xk_borderWidth), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)xk_borderWidth {
    return [objc_getAssociatedObject(self, cornerRadiusWidth_radiusKey_border) floatValue];
}

static const char *cornerRadius_TypeKey_b = "cornerRadius_TypeKey_b";
- (void)setXk_borderType:(XKCornerBorderType)xk_borderType {
    if (xk_borderType == self.xk_borderType) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey_b, @(xk_borderType), OBJC_ASSOCIATION_RETAIN);
}

- (XKCornerBorderType)xk_borderType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey_b) unsignedIntegerValue];
}

static const char *cornerRadiusColor_LayerKey_border = "cornerRadiusColor_LayerKey_border";
- (void)setXk_borderColor:(UIColor *)xk_borderColor {
    if ([xk_borderColor isEqual:self.xk_borderColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_border, xk_borderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)xk_borderColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_border);
}

static const char *cornerRadiusColor_LayerKey_borderfill = "cornerRadius_ColColor";
- (void)setXk_borderFillColor:(UIColor *)xk_borderfillColor {
    if ([xk_borderfillColor isEqual:self.xk_borderFillColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill, xk_borderfillColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)xk_borderFillColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill);
}


static const char *cornerRadius_LayerKey_border = "cornerRadius_LayerKey_border";
- (void)setSubBorderLayer:(CAShapeLayer *)subBorderLayer {
    objc_setAssociatedObject(self, cornerRadius_LayerKey_border, subBorderLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)subBorderLayer {
    return objc_getAssociatedObject(self, cornerRadius_LayerKey_border);
}

static const char *cornerRadius_StatusKey_border = "cornerRadius_StatusKey_border";
- (void)setBorderStatusChange:(BOOL)borderStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey_border, @(borderStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)borderStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey_border) boolValue];
}


@end
