package com.winterhack.winterhack_2021;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import io.flutter.Log;

public class AlertReceiver extends BroadcastReceiver {
    private static String TAG = "AlertReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        //Implement code here
        Log.d(TAG, "Alarm Service has started!");
    }
}
