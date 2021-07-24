package com.winterhack.winterhack_2021;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import io.flutter.Log;

public class AlertReceiver extends BroadcastReceiver {
    private static String TAG = "AlertReceiver";

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onReceive(Context context, Intent intent) {
        String appName;
        ArrayList<String> disabledApps = intent.getStringArrayListExtra("Disabled apps");

        ActivityManager am = (ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        String fg=getForegroundProcess(context.getApplicationContext());
        Log.d(TAG, "check5: "+fg);

        try {
            appName = getAppNameFromPackageName(fg, context);
        } catch (Exception e) {
            Log.d(TAG, "No name");
            appName = null;
        }

        Log.d(TAG, "check6: "+appName);
        //Log.d(TAG, "check7: "+getPackageNamefromAppName(appName, context));


        if(appName != null && disabledApps.contains(appName)){
            Log.d(TAG, "App name: "+appName);
            Intent startMain = new Intent(Intent.ACTION_MAIN);
            startMain.addCategory(Intent.CATEGORY_HOME);
            startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(startMain);
            am.killBackgroundProcesses(appName);
            //android.os.Process.sendSignal(getPackageNamefromAppName(fg, context), android.os.Process.SIGNAL_KILL);
            //amKillProcess(context, appName);
            Log.d(TAG, fg+" Killed!");
        }else {
        }
        Log.d(TAG, "Alarm Service has started!");

    }

    public void amKillProcess(Context context, String process)
    {
        ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        final List<ActivityManager.RunningAppProcessInfo> runningProcesses = am.getRunningAppProcesses();

        for(ActivityManager.RunningAppProcessInfo runningProcess : runningProcesses)
        {
            Log.d(TAG, runningProcess.processName);
            if(runningProcess.processName.equals(process))
            {
                Log.d(TAG, "reach here?");
                android.os.Process.sendSignal(runningProcess.pid, android.os.Process.SIGNAL_KILL);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public String getAppNameFromPackageName(String appPackageName, Context context) {
        PackageManager pm = context.getPackageManager();
        List<ApplicationInfo> apps = pm.getInstalledApplications(PackageManager.GET_META_DATA);
        return apps.stream().filter(app -> app.packageName.equals(appPackageName))
                .map(app -> app.name).findAny().orElse(null);
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
        Log.d(TAG, "check3");
        if(topPackageName==null) {
            Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
            context.startActivity(intent);
        }
        Log.d(TAG, "check4");
        Log.d(TAG, topPackageName);
        return topPackageName;

    }
}
