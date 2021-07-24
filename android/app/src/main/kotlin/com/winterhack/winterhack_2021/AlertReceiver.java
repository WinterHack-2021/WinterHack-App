package com.winterhack.winterhack_2021;

import android.annotation.TargetApi;
import android.app.ActivityManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.RequiresApi;

import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import io.flutter.Log;

public class AlertReceiver extends BroadcastReceiver {
    private static String TAG = "AlertReceiver";

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onReceive(Context context, Intent intent) {
        ActivityManager am = (ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        String fg=getForegroundProcess(context.getApplicationContext());
        if(fg != null && fg=="com.google.android.youtube"){
            Log.d(TAG, "App name: "+fg);
            am.killBackgroundProcesses(fg);
            Log.d(TAG, fg+" Killed!");
        }else {
        }
        Log.d(TAG, "Alarm Service has started!");
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public static String getForegroundProcess(Context context) {
        String topPackageName = null;
        UsageStatsManager usage = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
        long time = System.currentTimeMillis();
        List<UsageStats> stats = usage.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000*1000, time);
        if (stats.isEmpty()) {
            Log.d(TAG, "stats is empty");
        }
        if (stats != null) {
            SortedMap<Long, UsageStats> runningTask = new TreeMap<Long,UsageStats>();
            for (UsageStats usageStats : stats) {
                runningTask.put(usageStats.getLastTimeUsed(), usageStats);
            }
            Log.d(TAG, "check1");
            if (runningTask.isEmpty()) {
                return null;
            }
            Log.d(TAG, "check2");
            topPackageName =  runningTask.get(runningTask.lastKey()).getPackageName();
        }
        if(topPackageName==null) {
            Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
            context.startActivity(intent);
        }
        Log.d(TAG, topPackageName);
        return topPackageName;
    }
}
