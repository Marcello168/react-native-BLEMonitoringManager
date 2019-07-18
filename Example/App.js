/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, NativeModules, PermissionsAndroid, DeviceEventEmitter } from 'react-native';

const instructions = Platform.select({
    ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
    android: 'Double tap R on your keyboard to reload,\n' + 'Shake or press menu button for dev menu'
});

type Props = {};
export default class App extends Component<Props> {
    componentDidMount = () => {
        console.log('object :', NativeModules);
        // NativeModules.BLEMonitoringManager.shareBLEMonitoringManager();

        // this.requestLocationPermission();
    };

    async requestLocationPermission() {
        try {
            const granted = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION, {
                //第一次请求拒绝后提示用户你为什么要这个权限
                title: '我要地址查询权限',
                message: '没权限我不能工作，同意就好了'
            });

            if (granted === PermissionsAndroid.RESULTS.GRANTED) {
                // this.show('你已获取了地址查询权限');
            } else {
                // this.show('获取地址查询失败');
            }
        } catch (err) {
            // this.show(err.toString());
        }
    }

    render() {
        return (
            <View style={styles.container}>
                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('开始搜索 :');
                        NativeModules.BLEMonitoringManager.startScanDevice();
                    }}
                >
                    开始搜索
                </Text>

                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('开始链接 :');
                        NativeModules.BLEMonitoringManager.connectDevice('F0:F8:F2:EF:13:02');
                    }}
                >
                    开始链接
                </Text>

                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('发送 :');
                        let command1 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x03, 0xbc ];
                        let command2 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x00, 0x03, 0xab ];
                        let command3 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x00, 0xbf ];
                        let command4 = [ 0x5a, 0xa5, 0x01, 0x40, 0xbe ];

                        NativeModules.BLEMonitoringManager.sendDataToDevice(command1);
                    }}
                >
                    发送数据1
                </Text>
                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('发送 :');
                        let command1 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x03, 0xbc ];
                        let command2 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x00, 0x03, 0xab ];
                        let command3 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x00, 0xbf ];
                        let command4 = [ 0x5a, 0xa5, 0x01, 0x40, 0xbe ];

                        NativeModules.BLEMonitoringManager.sendDataToDevice(command2);
                    }}
                >
                    发送数据2
                </Text>
                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('发送 :');
                        let command1 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x03, 0xbc ];
                        let command2 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x00, 0x03, 0xab ];
                        let command3 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x00, 0xbf ];
                        let command4 = [ 0x5a, 0xa5, 0x01, 0x40, 0xbe ];

                        NativeModules.BLEMonitoringManager.sendDataToDevice(command3);
                    }}
                >
                    发送数据3
                </Text>
                <Text
                    style={styles.welcome}
                    onPress={() => {
                        console.log('发送 :');
                        let command1 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x03, 0xbc ];
                        let command2 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x00, 0x03, 0xa8 ];
                        let command3 = [ 0x5a, 0xa5, 0x04, 0x50, 0x00, 0x14, 0x00, 0xbf ];
                        let command4 = [ 0x5a, 0xa5, 0x01, 0x40, 0xbe ];

                        NativeModules.BLEMonitoringManager.sendDataToDevice(command4);
                    }}
                >
                    发送数据4
                </Text>
                <Text style={styles.instructions}>To get started, edit App.js</Text>
                <Text style={styles.instructions}>{instructions}</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF'
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5
    }
});
