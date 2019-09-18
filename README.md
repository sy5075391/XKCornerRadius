####俗话说UI有三宝，边框阴影加圆角。目前移动开发基本都是扁平化风格，很多UI设计都是边框阴影加圆角的套路，正常我们使用系统的layer就可以满足要求，虽然性能有些问题，但是始终能解决问题。但是如果涉及到某个角切圆角，或者在切指定某个圆角的同时加边框或者加阴影就比较蛋疼了。

> # 1   先介绍一下切圆角的场景
###切圆角的方式一般有两种。
######第一种，使用 UIView 内嵌的 layer，直接来切圆角，方便快捷。
```
UIImageView *userHeaderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
userHeaderImgView.layer.cornerRadius = 39;
userHeaderImgView.layer.masksToBounds = YES;
```

好处：方便快捷，2个属性就能搞定 UIView 的圆角切割。
坏处：切的圆角会产生混合图层，影响效率。尤其对于collectionView的cell上使用复用时，会很`影响帧数`。

######第二种，使用 CAShaperLayer 搭配 UIBezierPath 路径设置切割路径，然后把 layer 设置到 UIView 的 mask 属性上。
```
  UIImageView *userHeaderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
  CAShapeLayer *cornerLayer = [CAShapeLayer layer];
  UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:userHeaderImgView.bounds cornerRadius:39];
  cornerLayer.path = cornerPath.CGPath;
  cornerLayer.frame = userHeaderImgView.bounds;
  userHeaderImgView.layer.mask = cornerLayer;
```
好处：切割的圆角不会产生混合图层，提高效率，并且可以分别控制四个角的圆角。
坏处：代码量偏多， 该方式API都必须使用frame，所以对于使用使用约束布局的view就需要事先写死高度。不方便。

---
###实际运用
######项目中有时常用到卡片风格，首尾cell需要分别切上圆角和下圆角，cell也几乎是不定高度。所以针对第二种方式封装了适用于frame，约束布局的cell，提供了像系统切圆角的api，并且能指定切割圆角。
原理：view在layoutSubviews方法中的frame确定了，所以在该方法中进行layer的mask设置。通过runtime交换了方法，并且添加了相关的参数。
```
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sy_layoutSubviews);
        [self swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
    });
}
```
```
- (void)sy_layoutSubviews {
    [self sy_layoutSubviews];
    if (self.xk_openClip) {
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

```
---
####以下是详细使用

```
   self.view.backgroundColor = [UIColor whiteColor];
    _frameView = [[UILabel alloc] init];
    _frameView.backgroundColor = [UIColor redColor];
    _frameView.text = @"frame";
    _frameView.frame = CGRectMake(20, 100, 200, 100);
    
    _frameView.xk_openClip = YES;
    _frameView.xk_radius = 20;
    _frameView.xk_clipType = XKCornerClipTypeTopRight|XKCornerClipTypeBottomLeft;
    
    [self.view addSubview:_frameView];
    
    _masonryView = [[UILabel alloc] init];
    _masonryView.text = @"autoLayout";
    _masonryView.xk_openClip = YES;
    _masonryView.xk_radius = 20;
    _masonryView.backgroundColor = [UIColor orangeColor];
    _masonryView.xk_clipType = XKCornerClipTypeTopRight|XKCornerClipTypeTopLeft;
    
    [self.view addSubview:_masonryView];
    
    [_masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frameView.mas_bottom).offset(40);
        make.left.equalTo(self.frameView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
```

![切圆角实例](https://upload-images.jianshu.io/upload_images/1956050-d38159c60c0637b9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> # 2  切圆角场景下加边框或者是加阴影
###### 第一种 对于加边框和加阴影的情况，不过不涉及指定切圆角，那么可以使用
```
    UIView *aa1 = [[UIView alloc] init];
    [KEY_WINDOW addSubview:aa1];
    aa1.backgroundColor = [UIColor redColor];
    aa1.frame = CGRectMake(100, 300, 100, 50);
  // 圆角
    aa1.layer.cornerRadius = 10;
// 边框
    aa1.layer.borderColor = [UIColor orangeColor].CGColor;
    aa1.layer.borderWidth = 5;
// 阴影
    aa1.layer.shadowColor = [UIColor blackColor].CGColor;
    aa1.layer.shadowOffset = CGSizeMake(2, 2);
    aa1.layer.shadowRadius = 10;
    aa1.layer.shadowOpacity = 0.5;
```

######第二种， 同样使用 CAShaperLayer 搭配 UIBezierPath 路径实现，不同的是不能设置在UIView.layer的mask属性，因为会导致阴影被切掉。使用addSublayer

原理同上交换方法。
```
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
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width -  self.xk_borderWidth, self.height - self.xk_borderWidth) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.xk_borderRadius, self.xk_borderRadius)];
            self.subBorderLayer.frame = CGRectMake(self.xk_borderWidth / 2, self.xk_borderWidth / 2,self.width - self.xk_borderWidth,self.height - self.xk_borderWidth);
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
```

####使用
```
 UIView *aa = [[UIView alloc] init];
 [KEY_WINDOW addSubview:aa];
 aa.frame = CGRectMake(20, 300, 100, 50);
 aa.xk_openBorder = YES; // 开启功能
 aa.xk_borderFillColor = [UIColor redColor]; // 视图背景颜色这样设置
 aa.xk_borderType = XKBorderTypeTopLeft; // 指定下方圆角
 aa.xk_borderRadius = 20; // 圆角大小
 aa.xk_borderColor = [UIColor orangeColor]; // 边框颜色
 aa.xk_borderWidth = 2; // 边框宽度
 // 阴影还是系统的方法
 aa.layer.shadowColor = [UIColor blackColor].CGColor;
 aa.layer.shadowOffset = CGSizeMake(2, 2);
 aa.layer.shadowRadius = 10;
 aa.layer.shadowOpacity = 0.5;
```
![效果](https://upload-images.jianshu.io/upload_images/1956050-1789d75db866db97.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




---

#####以上的方法通过组合基本可以应对所有的情况了。上述两个分类在这里
https://github.com/sy5075391/XKCornerRadius


为了方便使用也可以使用pod安装
-----
## Installation


```ruby
pod 'XKCornerRadius'
```

## Author

Jamesholy, 447523382@qq.com,https://www.jianshu.com/u/2df38653a8d4
