//
//  BLEMonitoringManager.m
//  BLEMonitoringManager
//
//  Created by gongyonghui on 2019/7/10.
//  Copyright © 2019 DLC. All rights reserved.
//

#import "BLEMonitoringManager.h"
#import "BLEManager.h"
#import "DataTool.h"

@interface BLEMonitoringManager ()<BLEManagerDelegate>{
    NSMutableArray *_scanDevices;//扫描到的设备

}

/** 蓝牙单例 */
@property (nonatomic, strong) BLEManager *bleManager;

@end

@implementation BLEMonitoringManager

RCT_EXPORT_MODULE(BLEMonitoringManager);

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"ScanDeviceListResult",@"Monitoringttitudeata"];
}

RCT_EXPORT_METHOD(shareBLEMonitoringManager){
    RCTLogInfo(@"创建单例蓝牙");
    _scanDevices = [NSMutableArray array];
    BLEManager * manager = [BLEManager defaultManager];
    manager.delegate = self;
    self.bleManager = manager;
    
}

RCT_EXPORT_METHOD(testPrint:(NSString *)name info:(NSDictionary *)info) {
    RCTLogInfo(@"%@: %@", name, info);
    [self.bleManager scanDeviceTime:3.0];

}

/***开始搜索设备**/
RCT_EXPORT_METHOD(startScanDevice ) {
    [self.bleManager scanDeviceTime:3.0];
    
}

RCT_EXPORT_METHOD(connectDevice:(NSString *)macAddress) {
    
    DeviceInfo * connectDevcie = [self getReadyConectPeriphera:macAddress];
    [self.bleManager connectToDevice:connectDevcie.cb];
    
}

- (DeviceInfo *) getReadyConectPeriphera:(NSString *)macAddress{
    NSLog(@"getReadyConectPeriphera");
    DeviceInfo *device = nil ;
    for (DeviceInfo  *scanDevice in _scanDevices) {
        if ([scanDevice.macAddrss isEqualToString:macAddress]) {
            device = scanDevice;
            break;
        }
    }
    
    return device;
}

//发送数据NS啊
RCT_EXPORT_METHOD(sendDataToDevice:(NSArray*)commandArray) {
    
    NSString *str = [DataTool convertArrayToHexStr:commandArray];
    NSLog(@"Send Hex Str -> %@", str);
//    [self.bleManager scanDeviceTime:3.0];
    
}


/*************BLEManagerDelegate代理回调*****************/

///**
// *  控制中心状态回调
// *
// */
- (void)centerManagerStateChange:(CBCentralManager *)center{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}


/**
 *  搜索到设备回调方法
 *
 *  @param array 设备数组
 */
- (void)scanDeviceRefrash:(NSMutableArray *)array{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);
    for (DeviceInfo *info in array) {
        if (![_scanDevices containsObject:info]) {
            [_scanDevices addObject:info];
        }
    }
    NSMutableArray *devcieArray = [NSMutableArray array];
    for (DeviceInfo *deviceinfo in _scanDevices) {
        NSDictionary *deviceDict = @{@"deviceName":deviceinfo.localName,@"deviceAddress":deviceinfo.macAddrss,@"deviceRSSI":@(deviceinfo.RSSI)};
        [devcieArray addObject:deviceDict];
    }
    //处理数据后发给JS
    [self sendEventWithName:@"ScanDeviceListResult" body:devcieArray];

}

- (void)bleManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);
    

}



/**
 *  连接设备成功回调方法
 *
 *  @param device 设备对象
 *  @param error  错误信息
 */
- (void)connectDeviceSuccess:(CBPeripheral *)device error:(NSError *)error{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}



/**
 *  断开设备成功回调
 *
 *  @param device 设备对象
 *  @param error  错误信息
 */
- (void)didDisconnectDevice:(CBPeripheral *)device error:(NSError *)error{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}



/**
 *  收到数据回调方法(1002)
 *
 *  @param data   数据
 *  @param device 设备对象
 */
- (void)receiveDeviceDataSuccess_1:(NSData *)data device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);
    NSString *hexStr =  [DataTool convertDataToHexStr:data];
    NSLog(@"HexStr: = %@",hexStr);
    Byte *commandByte = (Byte *)[data bytes];
    NSMutableArray *commandArray = [NSMutableArray array];

    for(int i=0;i<[data length];i++){
      int cmd =  commandByte[i];
        [commandArray addObject:@(cmd)];
    }
    //处理数据后发给JS
    [self sendEventWithName:@"Monitoringttitudeata" body:commandArray];
    NSLog(@"commandArray-> %@",commandArray);

}



/**
 *  收到数据回调方法(1003)
 *
 *  @param data   数据
 *  @param device 设备对象
 */
- (void)receiveDeviceDataSuccess_3:(NSData *)data device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

- (void)Receive_Data_EventfromModel:(NSData *)TXP p:(UInt8)len DEV:(CBPeripheral *)cb AndMarkId:(NSInteger)markId{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}//读取设备电池电量，此接口为防丢器专用

/**
 *  可以开始选取 OAD 文件进行 OAD 升级的回调
 *  (这个是2541 A,B 版升级时会用到的回调)
 *  @param fileType  OAD升级选取文件的类型 fileType为A选取A版bin文件 fileType为B选取B版bin文件
 */
- (void)didCanSelectOADFileWithFileType:(char)fileType{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  oad升级过程中发送文件的进度的回调
 *
 *  @param filePer 发送的文件的进度
 */
- (void)returnSendOADFileProgressWith:(float)filePer{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  oad升级成功的回调
 */
- (void)returnSendOADSuccess{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  oad 升级失败的回调
 */
- (void)returnSendOADFailure{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  停止搜索回调
 */
- (void)stopScanDevice{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  获取特征下的描述的值的回调(descriptor.value)
 */
- (void)receiveDeviceDescriptorValue:(NSString *)data withCharacteristic:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  获取到指定设备的某个服务下的某个特征的值后的回调
 */
- (void)bleManagerPeripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  发送数据成功的回调
 */
- (void)bleManagerPeripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  操作 notify 的回调
 */
- (void)bleManagerPeripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}


#pragma mark - extra(common)
/**
 *  读取设备版本号回调方法
 *
 *  @param version 版本信息
 *  @param device  设备对象
 */
- (void)receiveDeviceVersion:(NSString *)version device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备电量回调方法
 *
 *  @param battery 电量值
 *  @param device  设备对象
 */
- (void)receiveDeviceBattery:(NSInteger)battery device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备时钟寄存器回调方法
 *
 *  @param year   年
 *  @param month  月
 *  @param day    日
 *  @param hour   时
 *  @param monute 分
 *  @param second 秒
 *  @param device 设备对象
 */
- (void)receiveDeviceUTFTime:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)monute second:(NSInteger)second device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备波特率回调方法
 *
 *  @param rate   波特率  9600bps   19200bps   38400bps   57600bps   115200bps
 *  @param device 设备对象
 */
- (void)receiveDeviceChannelRate:(NSString *)rate device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备TX发射功率回调方法
 *
 *  @param txPower  TX发射功率 -23dbm  -6dbm  0dbm  4dbm
 *  @param device  设备对象
 */
- (void)receiveDeviceTXPower:(NSString *)txPower device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备名称回调方法
 *
 *  @param name   设置名称
 *  @param device 设备对象
 */
- (void)receiveDeviceSettingName:(NSString *)name device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备配对密码回调方法
 *
 *  @param password
 设置配对密码
 *  @param device   设备对象
 */
- (void)receiveDeviceSettingPassword:(NSString *)password device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备广播时间间隔回调方法
 *
 *  @param interval 广播时间间隔(单位：ms)
 *  @param device   设备对象
 */
- (void)receiveDeviceAdvertInterval:(NSInteger)interval device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备的连接时间间隔回调方法
 *
 *  @param interval 连接时间间隔(单位：ms)
 *  @param device   设备对象
 */
- (void)receiveDeviceConnectInterval:(NSInteger)interval device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备从机延时间隔回调方法
 *
 *  @param interval 延时间隔(单位：ms)
 *  @param device   设备对象
 */
- (void)receiveDeviceLatency:(NSInteger)interval device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备连接超时时间回调方法
 *
 *  @param interval 连接超时时间(单位：ms)
 *  @param device   设备对象
 */
- (void)receiveDeviceConnectTimeOut:(NSInteger)interval device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取设备广播数据回调方法
 *
 *  @param dataStr 设备广播数据
 *  @param device  设备对象
 */
- (void)receiveDeviceAdvertData:(NSString *)dataStr device:(CBPeripheral *)device{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  读取连接的设备的信号的回调方法
 */
- (void)readDeviceRSSI:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}


#pragma mark - 180A服务相关的回调
/**
 *  得到设备模组型号信息的回调方法
 */
- (void)receiveDeviceInfoModel:(NSString *)string withDevice:(CBPeripheral *)cb{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}

/**
 *  180A服务返回数据的回调
 */
- (void)receiveDeviceInfomation:(NSString *)string withPeripheral:(CBPeripheral *)cb{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);

}


#pragma mark - 2000服务相关的回调
- (void)receiveData:(NSData *)data with2000ServiceDevice:(CBPeripheral *)cb withCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);
}



@end
