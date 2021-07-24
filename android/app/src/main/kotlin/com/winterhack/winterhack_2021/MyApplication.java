package com.winterhack.winterhack_2021;

import android.app.Activity;
import android.app.Application;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

public class MyApplication extends Application {


        public void onCreate() {
            super.onCreate();
        }

        private Activity mCurrentActivity = null;
        public Activity getCurrentActivity(){
            return mCurrentActivity;
        }
        public void setCurrentActivity(Activity mCurrentActivity){
            this.mCurrentActivity = mCurrentActivity;
        }

}