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
import android.util.Log;

import com.ble.ble.BleService;
import com.ble.utils.ToastUtil;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.widget.Toast;
import com.itdlc.blemonitoringmanager.util.LeDevice;
import java.util.ArrayList;
import com.itdlc.blemonitoringmanager.util.LeProxy;
import static android.content.ContentValues.TAG;

public class BLEMonitoringManagerModule extends ReactContextBaseJavaModule {

    private BleService mLeService;
    private BluetoothAdapter mBluetoothAdapter;
    private Handler mHandler ;
    private boolean mScanning;
    private final static String TAG = "ScanFragment";
    private static final long SCAN_PERIOD = 5000;
    private ArrayList<LeDevice> mLeDevices;
    private LeProxy mLeProxy;


    public BLEMonitoringManagerModule(ReactApplicationContext reactContext) {

        super(reactContext);
//        Looper.prepare();//增加部分
//        mHandler = new Handler();
//        Looper.loop();//增加部分
        mLeDevices = new ArrayList<>();

        mLeProxy = LeProxy.getInstance();
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

    }

    @Override
    public String getName() {
        return "BLEMonitoringManager";
    }


    @ReactMethod
    public void testPrint(String name, ReadableMap info) {
        Log.i(TAG, name);
        Log.i(TAG, info.toString());
        scanLeDevice(true);

    }

    private BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent.getAction())) {
                int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF);
                if (state == BluetoothAdapter.STATE_ON) {
                    scanLeDevice(true);
                }
                Log.d(TAG, "BluetoothAdapter State: "+state);
            }
        }
    };



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
            mHandler.removeCallbacks(mScanRunnable);
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

        }
    };




}
