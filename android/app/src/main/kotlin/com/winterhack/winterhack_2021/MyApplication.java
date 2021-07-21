package com.winterhack.winterhack_2021;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.geofencing.GeofencingService;

public class MyApplication extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        //Abhi's Code

        GeofencingService.setPluginRegistrant(this);
        //Vishal's Code
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel("winterhack-channel","Messages", NotificationManager.IMPORTANCE_LOW);
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }
    }
    //Abhi's Code
    public void registerWith(PluginRegistry registry) {registry.registrarFor("io.flutter.plugins.geofencing.GeofencingService");
  }

}