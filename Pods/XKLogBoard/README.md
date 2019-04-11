# XKCornerRadius

[![CI Status](https://img.shields.io/travis/sy5075391/XKCornerRadius.svg?style=flat)](https://travis-ci.org/sy5075391/XKCornerRadius)
[![Version](https://img.shields.io/cocoapods/v/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)
[![License](https://img.shields.io/cocoapods/l/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)
[![Platform](https://img.shields.io/cocoapods/p/XKCornerRadius.svg?style=flat)](https://cocoapods.org/pods/XKCornerRadius)

## Example

### 场景
开发时DEBUG时在Xcode里就能看到App运行时的打印在控制台里的日志，有些场景下我们还是需要实时查看App运行时的日志的，比如测试人员拿着测试机发现问题了过来找你，这时候要看运行时日志，又不能重新DEBUG安装版本，怎么办？测试时因为数据加密了没法抓包查看数据，只有真机调试看系统日志或者打断点，就很捉急了。还有测试人员测试时遇到崩溃，如果没有集成崩溃收集工具或者复现不容易，也会很麻烦。
### 方案
这里提供了一种方便的方法，就是将我们自己的log能在app内部实时显示，相当于一个app内置打印台，在想看日志的时候打开，方便于测试。以及app记录崩溃，重启时弹框显示。

![控制台](https://upload-images.jianshu.io/upload_images/1956050-785a18337d44449a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### app内置控制台效果
![app内置控制台](https://upload-images.jianshu.io/upload_images/1956050-6ff6387dbf855097.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 使用方法：
##### 1. 配置自己的NSLog
这样才能将log的信息自己进行处理 并进行显示

```
#ifdef DEBUG
#define NSLog(...) {NSTimeInterval time_interval = [[NSDate date]timeIntervalSince1970];\
NSString *logoInfo = [NSString stringWithFormat:__VA_ARGS__];\
printf("%f  %s\n",time_interval,[logoInfo UTF8String]); \
[[NSNotificationCenter defaultCenter] postNotificationName:@"xk_log_noti" object: [NSString stringWithFormat:@"%.2f %@\n %@\n",time_interval,[NSThread currentThread],logoInfo]];}
#else
#define NSLog(...)
#endif
```
将上面的宏放入工程的全局文件中，例如pch。如果工程中已经有类似的,只将通知的`[[NSNotificationCenter defaultCenter] postNotificationName:@"xk_log_noti" object: [NSString stringWithFormat:@"%.2f %@\n %@\n",time_interval,[NSThread currentThread],logoInfo]];`的这部分加入即可
##### 2. 内置打印台使用
使用只需要调用`[[XKConsoleBoard borad] show]`即可。
![搜索](https://upload-images.jianshu.io/upload_images/1956050-27da8c9ed382f67f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

XKConsoleBoard配置了*搜索*，*字体改变*，*位置拖动*，*大小改变* 的功能。
推荐使用快捷方式调用出该界面，比如摇一摇。该功能主要是进行网络请求的结果查看，所以在开发中DEBUG下进行网络请求入参，请求结果打印，可以方便开发与测试测试。

##### 2. 崩溃显示使用
![image.png](https://upload-images.jianshu.io/upload_images/1956050-749d815c08d42f24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
启用：``` [XKCrashRecord startRecord];```
调试时也记录：``` [XKCrashRecord enableSimulaterOrDebug];```
app启动时显示崩溃记录：` [XKCrashRecord showCrashInfoWithMoreInfo:@"当前环境：测试 api：xxx"];`

应测试，测试小妹崩溃了复制信息就往你的禅道丢了，再也不找你了。😂
   



## Requirements

## Installation

XKConsoleBoard is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XKConsoleBoard'
```

## Author

Jamesholy, 447523382@qq.com,https://www.jianshu.com/u/2df38653a8d4
Demo：https://github.com/sy5075391/XKConsoleBoard

## License

XKCornerRadius is available under the MIT license. See the LICENSE file for more info.
