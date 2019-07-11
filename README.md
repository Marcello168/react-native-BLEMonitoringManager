# react-native-BLEMonitoringManager

### DLC  迪尔西  React native   蓝牙SDK

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

