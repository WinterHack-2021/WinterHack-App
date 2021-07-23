package com.winterhack.winterhack_2021;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.util.List;

import io.flutter.Log;

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

            String currentRunningApp = getForegroundApplication(this);

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

    public String getForegroundApplication(Context context){
        ActivityManager am=(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        ActivityManager.RunningTaskInfo foreground=am.getRunningTasks(1).get(0);
        return foreground.topActivity.getPackageName();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}