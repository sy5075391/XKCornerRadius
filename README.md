# XKCornerRadius

[![CI Status](https://img.shields.io/travis/sy5075391/XKCornerRadius.svg?style=flat)](https://travis-ci.org/sy5075391/XKCornerRadius)
[![Version](https://img.shields.io/cocoapods/v/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)
[![License](https://img.shields.io/cocoapods/l/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)
[![Platform](https://img.shields.io/cocoapods/p/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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
![Simulator Screen Shot - iPhone X - 2018-12-29 at 17.18.47.png](https://upload-images.jianshu.io/upload_images/1956050-e3545b9307f045cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## Requirements

## Installation

XKCornerRadius is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XKCornerRadius'
```

## Author

Jamesholy, 447523382@qq.com,https://www.jianshu.com/u/2df38653a8d4

## License

XKCornerRadius is available under the MIT license. See the LICENSE file for more info.
