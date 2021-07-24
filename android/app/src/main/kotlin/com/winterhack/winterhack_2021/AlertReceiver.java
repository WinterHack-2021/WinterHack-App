package com.winterhack.winterhack_2021;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import java.lang.reflect.Field;
import java.util.List;

import io.flutter.Log;

public class AlertReceiver extends BroadcastReceiver {
    private static String TAG = "AlertReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        //Implement code here
        Log.d(TAG, "Alarm Service has started!");

        String currentRunningApp = getForegroundApplication(context);

        try {
            if (currentRunningApp.equals("com.gmail")) {
                ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);

                Intent startMain = new Intent(Intent.ACTION_MAIN);
                startMain.addCategory(Intent.CATEGORY_HOME);
                startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(startMain);
                Log.d(TAG, "App detected!!!!!");

                am.killBackgroundProcesses(currentRunningApp);
            }
        } catch (Exception e){
            Log.d(TAG, "Something went wrong!");
        }
        Log.d(TAG, "Task ended!");
    }

    public String getForegroundApplication(Context context){
//        ActivityManager mActivityManager =(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
//        String appPackageName;
//
//        if(Build.VERSION.SDK_INT > 21){
//            appPackageName = mActivityManager.getRunningAppProcesses().get(0).processName;
//        }
//        else{
//            appPackageName = mActivityManager.getRunningTasks(1).get(0).topActivity.getPackageName();
//        }
//
//        try {
//            Log.d(TAG, appPackageName);
//            return appPackageName;
//        } catch (Exception e) {
//                Log.d(TAG, "No package present!");
//                return null;
//        }


        ActivityManager mActivityManager =(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        String appPackageName;



        if (Build.VERSION.SDK_INT > 21) {
            final int PROCESS_STATE_TOP = 2;
            ActivityManager.RunningAppProcessInfo currentInfo = null;
            Field field = null;
            try {
                field = ActivityManager.RunningAppProcessInfo.class.getDeclaredField("processState");
            } catch (Exception ignored) {
            }
            ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningAppProcessInfo> appList = am.getRunningAppProcesses();
            for (ActivityManager.RunningAppProcessInfo app : appList) {
                if (app.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                        && app.importanceReasonCode == ActivityManager.RunningAppProcessInfo.REASON_UNKNOWN) {
                    Integer state = null;
                    try {
                        state = field.getInt(app);
                    } catch (Exception e) {
                    }
                    if (state != null && state == PROCESS_STATE_TOP) {
                        currentInfo = app;
                        break;
                    }
                }
            }
            try {
                Log.d(TAG, currentInfo.processName);
                return currentInfo.processName;
            } catch (Exception e) {
                Log.d(TAG, "No package present!");
                e.printStackTrace();
                return null;
            }

        } else {
            appPackageName = mActivityManager.getRunningTasks(1).get(0).topActivity.getPackageName();
        }
        return appPackageName;
    }
}


