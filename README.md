# react-native-BLEMonitoringManager

### DLC  迪尔西  React native  蓝牙检测 SDK

#### 1. 初始化 Setup

```sh
npm install --save react-native-BLEMonitoringManager
# --- or ---
yarn add react-native-BLEMonitoringManager
```

_📌 记得添加蓝牙权限到 `AndroidManifest.xml` for android and
`Info.plist` for iOS (Xcode >= 8). See [iOS Notes](#ios-notes) or [Android Notes](#android-notes) for more details._

#### 2. Using react-native link 链接到原生库 

```sh
react-native link react-native-BLEMonitoringManager
```

---
#### 注意事项 iOS
---
1. 该静态文件不支持 bitcode, 在工程中 TARGETS -> Build Settings ->Build Options -> Enable Bitcode 设置为 NO
2. 如果需要调试,请在真机上调试, libBLEManager 不支持模拟器上面的调试


#### 注意事项 android 

1. Android 从 4.3 开始支持 BLE，所以需在 AndroidManifest.xml 中添加如下 配置
```

<uses-sdkandroid:minSdkVersion="18"/>
<uses-permissionandroid:name="android.permission.BLUETOOTH" />
<uses-permissionandroid:name=android.permission.BLUETOOTH_ADMIN" />

```

2.  蓝牙功能需要用到一个关键服务 BleService，需在 AndroidManifest.xml 中添
加如下配置:

```

<service android:name="com.ble.ble.BleService" android:enabled="true"android:exported="false"/>

```

3. 在android 6.0之后用到蓝牙搜索的时候是需要开启模糊定位权限的，模糊定位是一个危险权限，故需要用到谷歌官方推荐的方法来解决；在应用启动之后 应该马上请求 定位权限

```js

async requestLocationPermission() {
try {
const granted = await       PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION, {
//第一次请求拒绝后提示用户你为什么要这个权限
title: '我要地址查询权限',
message: '没权限我不能工作，同意就好了'
});

if (granted === PermissionsAndroid.RESULTS.GRANTED) {
//用户同意定位成功 才可以开始搜索蓝牙
} else {
//用户拒绝定位  是不可能搜索到蓝牙设备的

}
} catch (err) {
// this.show(err.toString());
}
}
```



