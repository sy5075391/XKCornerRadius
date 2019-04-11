//
//  XKDeviceDataLibrery.h
//  XKSquare
//
//  Created by Jamesholy on 2018/8/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XKDeviceDataLibrery : NSObject
+ (instancetype)sharedLibrery;
/** 获取设备名称 */
- (const NSString *)getDiviceName;
/** 获取设备初始系统型号 */
- (const NSString *)getInitialVersion;
/** 获取设备支持的最高系统型号 */
- (const NSString *)getLatestVersion;
/** 获取设备电池容量，单位 mA 毫安 */
- (NSInteger)getBatteryCapacity;
/** 获取电池电压，单位 V 福特 */
- (CGFloat)getBatterVolocity;
/** 获取CPU处理器名称 */
- (const NSString *)getCPUProcessor;

@end
