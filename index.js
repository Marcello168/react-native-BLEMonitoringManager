/*
 * @Author: gongyonghui
 * @Date: 2019-07-11 08:58:54
 * @LastEditors: gongyonghui
 * @LastEditTime: 2019-07-15 18:29:32
 * @Description: file content
 */

import React, { NativeModules } from 'react';

let modbusInstance = null;
export default class BLEMonitoringManager {
    constructor() {
        if (!modbusInstance) {
            modbusInstance = this;
            //监听接收串口开关的状态
            console.log('BLEMonitoringManager');
        }
        return modbusInstance;
    }

    /***
  * 类方法
  */
    static ShareInstance() {
        let singleton = new BLEMonitoringManager();
        return singleton;
    }

    /**
     * 开始搜索
     */
    startScanDevice() {
        console.log('开始搜索 :');
        NativeModules.BLEMonitoringManager.startScanDevice();
    }

    /**
     * 连接指定的mac地址的数据
     * @param {*} macAddrss 
     */
    connectDevice(macAddrss) {
        console.log('开始链接 :', macAddrss);
        NativeModules.BLEMonitoringManager.connectDevice(macAddrss);
    }

    /**
   * 发送命令
   * @param {*} commandArray 
   */
    sendDataToDevice(commandArray) {
        NativeModules.BLEMonitoringManager.sendDataToDevice(commandArray);
    }

    /**
     * 校准设备
     * @param {* 时间} time 
     * @param {* 角度} Angle 
     */
    correctingDevcieCommand(time, Angle) {
        let time1 = 20; //振动时间 time //姿态不良敏感时间 0～255
        let checkSum = 0;
        let start = 0x01; ///振动启停 0：关闭； 1：打开
        let command = [ 0x5a, 0xa5, 0x04, Angle, time, start, time1 ];
        for (let index = 0; index < command.length; index++) {
            const element = command[index];
            checkSum = checkSum ^ element;
        } //检验
        command.push(checkSum);
    }
}

export const BLEMonitoringManager = BLEMonitoringManager.ShareInstance();
