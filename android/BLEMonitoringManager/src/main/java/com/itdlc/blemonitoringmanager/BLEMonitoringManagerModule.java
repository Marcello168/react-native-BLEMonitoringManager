package com.itdlc.blemonitoringmanager;

import android.bluetooth.BluetoothDevice;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.ble.api.DataUtil;
import com.ble.ble.BleService;
import com.ble.utils.TimeUtil;
import com.ble.utils.ToastUtil;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.widget.Toast;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.itdlc.blemonitoringmanager.util.LeDevice;
import java.util.ArrayList;
import com.itdlc.blemonitoringmanager.util.LeProxy;
import static android.content.ContentValues.TAG;
import static android.content.Context.BIND_AUTO_CREATE;
import android.content.pm.PackageManager;

import android.os.Bundle;
import android.os.IBinder;
import android.content.ContextWrapper;
public class BLEMonitoringManagerModule extends ReactContextBaseJavaModule implements LifecycleEventListener {


    /*****************/
    private static final String ScanDeviceListResult = "ScanDeviceListResult";//搜索到设备结果
    private static final String Monitoringttitudeata = "Monitoringttitudeata";//监测到数据变化


    private static final String E_PICKER_CANCELLED = "E_PICKER_CANCELLED";
    private static final String E_FAILED_TO_SHOW_PICKER = "E_FAILED_TO_SHOW_PICKER";
    private static final String E_NO_IMAGE_DATA_FOUND = "E_NO_IMAGE_DATA_FOUND";


    private BleService mLeService;
    private BluetoothAdapter mBluetoothAdapter;
    private Handler mHandler ;
    private boolean mScanning;
    private final static String TAG = "ScanFragment";
    private static final long SCAN_PERIOD = 5000;
    private ArrayList<LeDevice> mLeDevices;
    private LeProxy mLeProxy;
    private ReactApplicationContext reactContextjava;
//    private String lastCommand;
    private String connectMacAddress;


    public BLEMonitoringManagerModule(ReactApplicationContext reactContext) {

        super(reactContext);
        reactContextjava = reactContext;
//        mLeDevices = new ArrayList<>();
//        mLeProxy = LeProxy.getInstance();
//        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

    }

    @Override
    public String getName() {
        return "BLEMonitoringManager";
    }


    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableArray params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    WritableMap params = Arguments.createMap();

    /***初始化单例**/
    @ReactMethod
    public void shareBLEMonitoringManager() {
        mLeDevices = new ArrayList<>();
        mLeProxy = LeProxy.getInstance();
//        lastCommand = "";
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        getCurrentActivity().bindService(new Intent(getReactApplicationContext(), BleService.class), mConnection, BIND_AUTO_CREATE);
        getCurrentActivity().registerReceiver(mReceiver, makeFilter());
        LocalBroadcastManager.getInstance(reactContextjava).registerReceiver(mReceiver, makeFilter());

    }

    /***开始搜索设备**/
    @ReactMethod
    public void startScanDevice() {
        scanLeDevice(true);

    }

    /***开始连接设备**/
    @ReactMethod
    public void connectDevice(String macAddress) {
        connectMacAddress = macAddress;
        mLeProxy.connect(macAddress, false);
    }
    /***开始连接设备**/

    @ReactMethod
    public void sendDataToDevice(ReadableArray commandData) {
        byte[] commandByte = new byte[commandData.size()];

        for (int i = 0; i < commandData.size(); i++) {
commandByte[i] = (byte) commandData.getInt(i);
        }
        mLeProxy.send(connectMacAddress, commandByte);
    }




    private BroadcastReceiver mReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            Log.i(TAG, "onReceive: Intent " + intent.getAction());
            if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent.getAction())) {
                int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF);
                if (state == BluetoothAdapter.STATE_ON) {
                    scanLeDevice(true);
                    Log.i(TAG, "打开蓝牙 " + intent.getAction());
                } else {
                    Log.i(TAG, "关闭蓝牙 " + intent.getAction());

                }
            } else {
                switch (intent.getAction()) {

                    case LeProxy.ACTION_GATT_DISCONNECTED:// 断线
                        Log.i(TAG, "蓝牙 断线了 " + intent.getAction());

                        break;

                    case LeProxy.ACTION_RSSI_AVAILABLE: {// 更新rssi
                        Log.i(TAG, "蓝牙 更新rssi " + intent.getAction());

                    }
                    break;

                    case LeProxy.ACTION_GATT_CONNECTED: {// 更新rssi
                        Log.i(TAG, "蓝牙已连接 " + intent.getAction());//蓝牙连接后 马上停止扫描蓝牙
                        scanLeDevice(false);
                    }
                    break;

                    case LeProxy.ACTION_DATA_AVAILABLE:// 接收到从机数据
                        displayRxData(intent);
                        break;
                }
            }
        }
    };

        private void displayRxData(Intent intent) {
            String address = intent.getStringExtra(LeProxy.EXTRA_ADDRESS);
            String uuid = intent.getStringExtra(LeProxy.EXTRA_UUID);
            byte[] data = intent.getByteArrayExtra(LeProxy.EXTRA_DATA);
                String dataStr = "timestamp: " + TimeUtil.timestamp("MM-dd HH:mm:ss.SSS") + '\n'
                        + "uuid: " + uuid + '\n'
                        + "length: " + (data == null ? 0 : data.length) + '\n';

                    dataStr += "data: " + DataUtil.byteArrayToHex(data) + '\n';
            Log.i(TAG, "蓝牙 接收到数据 " +dataStr );
            WritableArray writableArray = Arguments.createArray();
            for (int i = 0; i < data.length; i++) {
                 int d = data[i] & 0xff;//Byte 转Int
                 writableArray.pushInt(d);
            }
            sendEvent(reactContextjava,Monitoringttitudeata,writableArray);//发送数据给JS

        }


    /**
     * 扫描BLE设备
     *
     * @param enable true开始扫描，false停止扫描
     */
    private void scanLeDevice(final boolean enable) {
        if (enable) {
            if (mBluetoothAdapter.isEnabled()) {
                if (mScanning) return;
                mScanning = true;
//                mHandler.postDelayed(mScanRunnable, SCAN_PERIOD);
                mBluetoothAdapter.startLeScan(mLeScanCallback);
            } else {
            }
        } else {
            mBluetoothAdapter.stopLeScan(mLeScanCallback);
//            mHandler.removeCallbacks(mScanRunnable);
            mScanning = false;
        }
    }


    private BluetoothAdapter.LeScanCallback mLeScanCallback = new BluetoothAdapter.LeScanCallback() {

        @Override
        public void onLeScan(final BluetoothDevice device, final int rssi, final byte[] scanRecord) {
            LeDevice ledevice = new LeDevice(device.getName(), device.getAddress(), rssi, scanRecord);
            Log.i(TAG,"Device Name->"+ledevice.getName() +"   Device Address->"+ledevice.getAddress()+" Devcie RSSI -> "+ ledevice.getRssi() );

            if (!mLeDevices.contains(ledevice)) {//添加设备
                mLeDevices.add(ledevice);
                WritableArray writableArray = Arguments.createArray();
                for (int i = 0; i < mLeDevices.size(); i++) {
                    LeDevice newledevice = mLeDevices.get(i);
                    WritableMap params = Arguments.createMap();
                    params.putString("deviceName",newledevice.getName());
                    params.putString("deviceAddress",newledevice.getAddress());
                    params.putInt("deviceRSSI",newledevice.getRssi());
                    writableArray.pushMap(params);
                }
                sendEvent(reactContextjava,ScanDeviceListResult,writableArray);
            }

        }
    };


    private final Runnable mScanRunnable = new Runnable() {
        @Override
        public void run() {
            scanLeDevice(false);
        }
    };


    private final ServiceConnection mConnection = new ServiceConnection() {

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.w(TAG, "onServiceDisconnected()");
        }

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            LeProxy.getInstance().setBleService(service);
            Log.w(TAG, "onServiceConnected()");

        }
    };


    private IntentFilter makeFilter() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(LeProxy.ACTION_GATT_CONNECTED);
        filter.addAction(LeProxy.ACTION_GATT_DISCONNECTED);
        filter.addAction(LeProxy.ACTION_CONNECT_ERROR);
        filter.addAction(LeProxy.ACTION_CONNECT_TIMEOUT);
        filter.addAction(LeProxy.ACTION_GATT_SERVICES_DISCOVERED);
        filter.addAction(LeProxy.ACTION_GATT_SERVICES_DISCOVERED);
        filter.addAction(LeProxy.ACTION_GATT_DISCONNECTED);
        filter.addAction(LeProxy.ACTION_RSSI_AVAILABLE);
        filter.addAction(LeProxy.ACTION_DATA_AVAILABLE);
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);

        return filter;
    }


    /**
     * Called either when the host activity receives a resume event (e.g. {@link Activity#onResume} or
     * if the native module that implements this is initialized while the host activity is already
     * resumed. Always called for the most current activity.
     */
    @Override
    public void onHostResume() {

    }

    /**
     * Called when host activity receives pause event (e.g. {@link Activity#onPause}. Always called
     * for the most current activity.
     */
    @Override
    public void onHostPause() {

    }

    /**
     * Called when host activity receives destroy event (e.g. {@link Activity#onDestroy}. Only called
     * for the last React activity to be destroyed.
     */
    @Override
    public void onHostDestroy() {
//getCurrentActivity().unregisterReceiver(mReceiver);
        LocalBroadcastManager.getInstance(reactContextjava).unregisterReceiver(mReceiver);

        getCurrentActivity().unbindService(mConnection);
    }
}
