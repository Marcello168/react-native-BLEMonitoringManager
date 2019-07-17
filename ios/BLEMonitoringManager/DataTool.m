//
//  DataTool.m
//  BLEMonitoringManager
//
//  Created by gongyonghui on 2019/7/15.
//  Copyright © 2019 DLC. All rights reserved.
//

#import "DataTool.h"

@implementation DataTool

#pragma mark - ***********数据处理相关工具**********

+ (NSInteger)convertHexToDecimal:(NSString*)text range:(NSRange)range
{
    NSString *tempString = [text substringWithRange:range];
    if (range.length == 4) {//2个字节
        return [self convertTextHexToDecimal:[self hith2LowByte:tempString]];
    }
    else//1个字节
    {
        return [self convertTextHexToDecimal:tempString];
    }
}

///将NSData转换成十六进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


///将十六进制字符串转成十进制数字
+ (long long)convertTextHexToDecimal:(NSString *)tmpid{
    
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:tmpid];
    [scanner scanHexLongLong:&result];
    
    return result;
    
}

//十进制转十六进制字符串
+ (NSString *)decimal2Hex:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number]; break;
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex;
}

//十六进制字符串转NSData
+ (NSData*)hexToBytes:(NSString*)string {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

//字符串前面自动补0，补充至设置长度
+ (NSString*)addZeroString:(NSString*)string length:(NSInteger)length
{
    NSMutableString *tempString = [NSMutableString stringWithString:string];
    while (tempString.length < length) {
        [tempString insertString:@"0" atIndex:0];
    }
    return tempString;
}

//低8位高8位顺序
+ (NSString*)low2HighByte:(NSString*)string
{
    if (string.length < 4) {
        return string;
    }
    
    NSString *high_byte = [string substringWithRange:NSMakeRange(0, 2)];
    NSString *low_byte = [string substringWithRange:NSMakeRange(2, 2)];
    return [NSString stringWithFormat:@"%@%@", low_byte, high_byte];
}

//高8位低8位顺序
+ (NSString*)hith2LowByte:(NSString*)string
{
    if (string.length < 4) {
        return string;
    }
    
    NSString *high_byte = [string substringWithRange:NSMakeRange(2, 2)];
    NSString *low_byte = [string substringWithRange:NSMakeRange(0, 2)];
    return [NSString stringWithFormat:@"%@%@", high_byte, low_byte];
}



#pragma mark -- 10进制转16进制
+ (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        
        switch (ttmpig)
        {
            case 10:   nLetterValue =@"A";break;
            case 11:   nLetterValue =@"B";break;
            case 12:   nLetterValue =@"C";break;
            case 13:   nLetterValue =@"D";break;
            case 14:   nLetterValue =@"E";break;
            case 15:   nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    str = str.length == 1 ? [NSString stringWithFormat:@"0%@",str] : str ;
    return str;
}

+ (NSString *)ToHex2:(int)tmpid
{
    NSString *str =@"";
    int tmpid2;
    
    do {
        tmpid2 = tmpid%256;
        tmpid = tmpid/256;
        str = [NSString stringWithFormat:@"%@%@", [self ToHex:tmpid2],str];
    } while (tmpid != 0);
    
    return str;
}

///将数组的数字转换成十六进制的字符串
+ (NSString *)convertArrayToHexStr:(NSArray *)array {
    NSMutableString *str = [NSMutableString string];
    for (NSNumber *number in array) {
      NSString *hexStr = [self ToHex:number.intValue];
        [str appendString:hexStr];
    }
    return  str;
}

@end
