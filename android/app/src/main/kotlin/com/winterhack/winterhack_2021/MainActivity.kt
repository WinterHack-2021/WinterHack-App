package com.winterhack.winterhack_2021
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.ActivityManager.RunningTaskInfo
import android.content.Context
import android.app.ActivityManager

import android.Manifest.permission
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import androidx.annotation.Nullable
import androidx.core.content.ContextCompat
import androidx.appcompat.app.AppCompatActivity


import com.google.android.libraries.places.api.Places
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.tasks.Task
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.PlaceLikelihood
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest
import com.google.android.libraries.places.api.net.FindCurrentPlaceResponse
import com.google.android.libraries.places.api.net.PlacesClient

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            run {
                println("Hello");
                if (call.method == "disablerEnabler") {
                    val appResult = disablerEnabler()
                    result.success(appResult)
                } else if (call.method == "getcurrentlocation") {
                    val appResult = getcurrentlocation()
                    result.success(appResult)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            }
        }
    }

    private fun disablerEnabler(): String {
        return "Suuup";

    }
//        String currentRunningApp = TaskChecker.getForegroundApplication(yourContext);
//
//        if(currentRunningApp.equals("com.whatsapp")){
//            ActivityManager am = (ActivityManager)yourContext.getSystemService(Context.ACTIVITY_SERVICE);
//
//            Intent startMain = new Intent(Intent.ACTION_MAIN);
//            startMain.addCategory(Intent.CATEGORY_HOME);
//            startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            this.startActivity(startMain);
//
//            am.killBackgroundProcesses(currentRunningApp );
//        }

    private fun getcurrentlocation(): String {
        // Initialize the SDK
        fun getLocationPermission() {
            TODO()
        }
        
        Places.initialize(applicationContext, "AIzaSyDIL0YfPsa_0ph6hN8AqCq-b-Xkv0dAS7A")

        // Create a new PlacesClient instance
        val placesClient = Places.createClient(this)
        


        // Use fields to define the data types to return.
        val placeFields: List<Place.Field> = listOf(Place.Field.NAME)
        // // Use the builder to create a FindCurrentPlaceRequest.
        val request: FindCurrentPlaceRequest = FindCurrentPlaceRequest.newInstance(placeFields)

        // Call findCurrentPlace and handle the response (first check that the user has granted permission).
        if (ContextCompat.checkSelfPermission(this, permission.ACCESS_FINE_LOCATION) ==
            PackageManager.PERMISSION_GRANTED) {

            val placeResponse = placesClient.findCurrentPlace(request)
            placeResponse.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val response = task.result
                    for (placeLikelihood: PlaceLikelihood in response?.placeLikelihoods ?: emptyList()) {
                        Log.i(
                            TAG,
                            "Place '${placeLikelihood.place.name}' has likelihood: ${placeLikelihood.likelihood}"
                        )
                    }
                } else {
                    val exception = task.exception
                    if (exception is ApiException) {
                        Log.e(TAG, "Place not found: ${exception.statusCode}")
                    }
                }
            }
        } else {
            // A local method to request required permissions;
            // See https://developer.android.com/training/permissions/requesting
            getLocationPermission()
        }
        
        return "yoyo";
    }

    
}
//
//public class TaskChecker{
//    public static String getForegroundApplication(Context context){
//        ActivityManager am=(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
//        RunningTaskInfo foreground=am.getRunningTasks(1).get(0);
//        return foreground.topActivity.getPackageName();
//    }
//}

