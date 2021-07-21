package com.winterhack.winterhack_2021

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.Manifest.permission
import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat


import com.google.android.libraries.places.api.Places
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.tasks.Task
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.PlaceLikelihood
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest
import com.google.android.libraries.places.api.net.FindCurrentPlaceResponse
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"
    private val TAG = "MainActivity"
    private var forService: Intent? = null


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //GeneratedPluginRegistrant.registerWith(flutterEngine)
        forService = Intent(this@MainActivity, MyService::class.java)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            run {
                if (call.method.equals("disablerEnabler")) {
                    val appResult = disablerEnabler()
                    result.success(appResult)
                } else if (call.method.equals("DisplayApps")) {
                    val appResult = DisplayApps()
                    result.success(appResult)
                } else if (call.method.equals("startService")) {
                    val appResult = startService()
                    result.success(appResult)
                } else if (call.method.equals("getcurrentlocation")) {
                    getcurrentlocation(result)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            }
        }
    }

    private fun DisplayApps(): MutableList<String> {
        val pm = packageManager
        //get a list of installed apps.
        val packages: List<ApplicationInfo> =
            pm.getInstalledApplications(PackageManager.GET_META_DATA)

        var apps: MutableList<String> = ArrayList<String>();
        apps.add("hiii")

        for (packageInfo in packages) {
            apps.add(packageInfo.packageName);
            Log.d(TAG, "Installed package :" + packageInfo.name)
            Log.d(TAG, "Installed package :" + packageInfo.packageName)
            Log.d(TAG, "Source dir : " + packageInfo.sourceDir)
            Log.d(TAG, "Launch Activity :" + pm.getLaunchIntentForPackage(packageInfo.packageName))
        }

        return apps;

    }

    private fun disablerEnabler(): String {


        val currentRunningApp: String? = TaskChecker.getForegroundApplication(context)

        if (currentRunningApp == "com.whatsapp") {
            val startMain = Intent(Intent.ACTION_MAIN)
            startMain.addCategory(Intent.CATEGORY_HOME)
            startMain.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            this.startActivity(startMain)
            val manager = getSystemService(Activity.ACTIVITY_SERVICE) as ActivityManager
            manager.killBackgroundProcesses(currentRunningApp)
            print("Successs!!!!!!!!!!!!")
        }
        return "random string";
    }

    object TaskChecker {
        fun getForegroundApplication(context: Context): String? {
            val am: ActivityManager =
                context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val foreground: ActivityManager.RunningTaskInfo = am.getRunningTasks(1).get(0)
            return foreground.topActivity?.packageName;
        }
    }

    private fun startService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(forService)
        } else {
            startService(forService)
        }
    }


    private fun getcurrentlocation(result: MethodChannel.Result) {
        // Initialize the SDK
        fun getLocationPermission() {
            TODO()
        }


        Places.initialize(applicationContext, "AIzaSyDIL0YfPsa_0ph6hN8AqCq-b-Xkv0dAS7A")

        // Create a new PlacesClient instance
        val placesClient = Places.createClient(this)

        // [START maps_places_current_place]
        // Use fields to define the data types to return.
        val placeFields: List<Place.Field> = listOf(Place.Field.NAME, Place.Field.TYPES)

        // Use the builder to create a FindCurrentPlaceRequest.
        val request: FindCurrentPlaceRequest = FindCurrentPlaceRequest.newInstance(placeFields)

        // Call findCurrentPlace and handle the response (first check that the user has granted permission).
        if (ContextCompat.checkSelfPermission(this, permission.ACCESS_FINE_LOCATION) ==
            PackageManager.PERMISSION_GRANTED
        ) {

            val placeResponse = placesClient.findCurrentPlace(request)
            placeResponse.addOnCompleteListener { task ->
                val placesList = arrayListOf<String>()
                val placesMap: HashMap<String, String> = HashMap<String, String>()
                if (task.isSuccessful) {
                    val response = task.result
                    for (placeLikelihood: PlaceLikelihood in response?.placeLikelihoods
                        ?: emptyList()) {
                        // println("Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}")
                        Log.i(
                            TAG,
                            "Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}"
                        )
                        placesList.add("Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}")
                        placesMap.put(
                            "${placeLikelihood.place.name}",
                            "${placeLikelihood.place.types}"
                        )
                    }
                    result.success(placesMap)
                } else {
                    val exception = task.exception
                    if (exception is ApiException) {
                        Log.e(TAG, "Place not found: ${exception.statusCode}")
                    }
                    result.error("UNAVAILABLE", "", exception.toString())
                }
            }
        } else {
            // A local method to request required permissions;
            // See https://developer.android.com/training/permissions/requesting
            // TODO throw error
        }
        // [END maps_places_current_place]
    }

    private fun getLocationPermission() {
        TODO()
    }

    companion object {
        private val TAG = MainActivity::class.java.simpleName

    }
}

