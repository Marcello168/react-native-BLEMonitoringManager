//
//  DataTool.h
//  BLEMonitoringManager
//
//  Created by gongyonghui on 2019/7/15.
//  Copyright © 2019 DLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTool : NSObject

///将NSData转换成十六进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

///将十六进制字符串转成十进制数字
+ (long long)convertTextHexToDecimal:(NSString *)tmpid;

///将数组的数字转换成十六进制的字符串
+ (NSString *)convertArrayToHexStr:(NSArray *)array ;

@end

NS_ASSUME_NONNULL_END
