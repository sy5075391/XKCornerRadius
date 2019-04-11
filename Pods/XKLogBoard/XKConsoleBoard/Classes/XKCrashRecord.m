/*******************************************************************************
 # File        : XKCrashRecord.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/12/19
 # Corporation :
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCrashRecord.h"
#import "XKAlertUtil.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>
#import "XKDeviceDataLibrery.h"
#define XKUserDefault [NSUserDefaults standardUserDefaults]


@implementation XKCrashRecord

static BOOL recordForSimulaterOrDebug = NO;
+ (void)startRecord {
#if DEBUG
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
#endif
}

+ (void)enableSimulaterOrDebug {
#if DEBUG
    recordForSimulaterOrDebug = YES;
#endif
}

+ (void)recordCrashInfo:(NSDictionary *)info {
    if (recordForSimulaterOrDebug) {
        [XKUserDefault setObject:info forKey:@"crashKey"];
    } else {
#if TARGET_IPHONE_SIMULATOR // 模拟器就不记录了
        
#else
        if (AmIBeingDebugged()) { // 真机调试也不记录了
            //return;
        }
        [XKUserDefault setObject:info forKey:@"crashKey"];
        
#endif
    }
}

+ (void)showCrashInfo {
    [self showCrashInfoWithMoreInfo:nil];
}

+ (void)showCrashInfoWithMoreInfo:(NSString *)moreInfo {
#if DEBUG
    NSDictionary *crashInfo = [XKUserDefault objectForKey:@"crashKey"];
    if (!crashInfo) {
        return;
    }
    [XKUserDefault setObject:nil forKey:@"crashKey"];
    NSString *time = [crashInfo[@"time"] stringValue];
    NSString *info = crashInfo[@"info"];
    NSString *title = [NSString stringWithFormat:@"崩溃报告:%@",[XKCrashRecord backStringWithFormatString:@"yyyy-MM-dd HH:mm" timestampString:time]];
    NSString *str = [NSString stringWithFormat:@"========环境========\n%@\n%@%@",[XKCrashRecord envirDetailInfo],moreInfo?[NSString stringWithFormat:@"%@\n",moreInfo]:@"",info];
    [XKAlertUtil presentAlertWithTitle:title message:str actionTitles:@[@"知道了",@"复制"] preferredStyle:UIAlertControllerStyleAlert handler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        if ([buttonTitle isEqualToString:@"复制"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard]; pasteboard.string = [NSString stringWithFormat:@"%@\n%@",title,str];
        }
    }];
#endif
}

// 异常捕捉
void UncaughtExceptionHandler(NSException *exception){
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========错误信息========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSMutableDictionary *crashDic = @{}.mutableCopy;
    crashDic[@"info"] = content;
    crashDic[@"time"] = @([[NSDate date] timeIntervalSince1970]);
    [XKCrashRecord recordCrashInfo:crashDic];
}


static bool AmIBeingDebugged(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}


+ (NSString *)backStringWithFormatString:(NSString *)formatString timestampString:(NSString *)timestampString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

+ (NSString *)envirDetailInfo {
    NSMutableArray *arr = @[].mutableCopy;
   
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [arr addObject:[NSString stringWithFormat:@"verion:%@",app_Version]];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    [arr addObject:[NSString stringWithFormat:@"buildVerion:%@",app_build]];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    [arr addObject:[NSString stringWithFormat:@"手机系统版本:%@",phoneVersion]];
    //手机型号
    [arr addObject:[NSString stringWithFormat:@"手机型号:%@",[XKCrashRecord currentModel]]];
    return [arr componentsJoinedByString:@"\n"];
}


+ (NSString *)currentModel {
    return (NSString *)[[XKDeviceDataLibrery sharedLibrery] getDiviceName];
}

@end
