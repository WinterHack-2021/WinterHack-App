package com.winterhack.winterhack_2021


import android.Manifest.permission
import android.app.ActivityManager
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import com.google.android.gms.common.api.ApiException
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.PlaceLikelihood
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*
import kotlin.collections.ArrayList


class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            run {
                println("Hello");
                if (call.method == "applists") {
                    val appResult = applists()
                    result.success(appResult)
                } else if (call.method == "disablerEnabler"){
                    val appResult = disablerEnabler()
                    result.success(appResult)
                }
                else if (call.method == "getcurrentlocation") {
                    val appResult = getcurrentlocation()
                    result.success(appResult)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            }
        }
    }

    private fun applists(): ArrayList<String> {
        val packageManager = packageManager
        val mainIntent = Intent(Intent.ACTION_MAIN, null)
        mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        val apps: ArrayList<String> = ArrayList<String>();

        val appList: MutableList<ResolveInfo> = packageManager.queryIntentActivities(mainIntent, 0)
        Collections.sort(appList, ResolveInfo.DisplayNameComparator(packageManager))
        val packs: List<PackageInfo> = packageManager.getInstalledPackages(0)
        for (i in packs.indices) {
            val p: PackageInfo = packs[i]
            val a: ApplicationInfo = p.applicationInfo
            // skip system apps if they shall not be included
            if (a.flags and ApplicationInfo.FLAG_SYSTEM === 1) {
                continue
            }
            apps.add(p.packageName)
        }

        return apps;
    }

    private fun disablerEnabler(): String {
        val mActivityManager = getSystemService(ACTIVITY_SERVICE) as ActivityManager
        val RunningTask = mActivityManager.getRunningTasks(1)
        val ar = RunningTask[0]
        var activityOnTop = ar.topActivity!!.className

        return "activityOnTop";
    }


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

