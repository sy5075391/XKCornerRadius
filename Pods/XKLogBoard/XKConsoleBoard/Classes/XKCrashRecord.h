/*******************************************************************************
 # File        : XKCrashRecord.h
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

#import <Foundation/Foundation.h>
#import "XKConsoleBoard.h"


@interface XKCrashRecord : NSObject

/**启动记录崩溃 debug下才会生效*/
+ (void)startRecord;

/**默认只有真机非调试状态下才会有崩溃报告  设置后 BEBUG下 真机调试和模拟器崩溃 也会显示崩溃报告 */
+ (void)enableSimulaterOrDebug;

/**展示崩溃记录 debug下才会生效*/
+ (void)showCrashInfo;
/**展示崩溃记录 顺表加入更多自定义信息*/
+ (void)showCrashInfoWithMoreInfo:(NSString *)moreInfo;

@end
