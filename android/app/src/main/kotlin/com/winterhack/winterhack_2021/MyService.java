package com.winterhack.winterhack_2021;

import android.app.ActivityManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.IBinder;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import io.flutter.Log;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.ConsoleHandler;

public class MyService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"winterhack-channel")
                    .setContentText("This is running in Background")
                    .setContentTitle("Flutter Background");

            startForeground(101,builder.build());


            System.out.println("Test Service Working or not");

            final PackageManager pm = getPackageManager();
            //get a list of installed apps.
            List<ApplicationInfo> packages = pm.getInstalledApplications(PackageManager.GET_META_DATA);

            for (ApplicationInfo packageInfo : packages) {
                if (pm.getLaunchIntentForPackage(packageInfo.packageName) != null) {
                    Log.d("TAG", "Installed name :" + packageInfo.name);
                    Log.d("TAG", "Installed package :" + packageInfo.packageName);
                    Log.d("TAG", "Source dir : " + packageInfo.sourceDir);
                    Log.d("TAG", "Launch Activity :" + pm.getLaunchIntentForPackage(packageInfo.packageName));
                }
            }

            String currentRunningApp = getForegroundApplication();

            if(currentRunningApp.equals("com.google.android.gm")){
                ActivityManager am = (ActivityManager)this.getSystemService(Context.ACTIVITY_SERVICE);

                Intent startMain = new Intent(Intent.ACTION_MAIN);
                startMain.addCategory(Intent.CATEGORY_HOME);
                startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                this.startActivity(startMain);
                Log.d("TAG", "App detected!!!!!");

                am.killBackgroundProcesses(currentRunningApp );
            }

        }

    }

    public String getForegroundApplication(){
        ActivityManager mActivityManager =(ActivityManager)this.getSystemService(Context.ACTIVITY_SERVICE);
        String appPackageName;

        if (Build.VERSION.SDK_INT > 21) {
            final int PROCESS_STATE_TOP = 2;
            ActivityManager.RunningAppProcessInfo currentInfo = null;
            Field field = null;
            try {
                field = ActivityManager.RunningAppProcessInfo.class.getDeclaredField("processState");
            } catch (Exception ignored) {
            }
            ActivityManager am = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
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
            return currentInfo.pkgList[0];
        } else {
            appPackageName = mActivityManager.getRunningTasks(1).get(0).topActivity.getPackageName().toString();
        }
        return appPackageName;
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}