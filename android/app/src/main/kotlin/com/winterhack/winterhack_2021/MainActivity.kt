package com.winterhack.winterhack_2021
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.Manifest.permission
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.content.ContextCompat


import com.google.android.libraries.places.api.Places
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.tasks.Task
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.PlaceLikelihood
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest
import com.google.android.libraries.places.api.net.FindCurrentPlaceResponse

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            run {
                if (call.method == "disablerEnabler") {
                    val appResult = disablerEnabler()
                    result.success(appResult)
                } else if (call.method == "getcurrentlocation") {
                    getcurrentlocation(result)
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
            PackageManager.PERMISSION_GRANTED) {

            val placeResponse = placesClient.findCurrentPlace(request)
            placeResponse.addOnCompleteListener { task ->
                val placesList = arrayListOf<String>()
                if (task.isSuccessful) {
                    val response = task.result
                    for (placeLikelihood: PlaceLikelihood in response?.placeLikelihoods ?: emptyList()) {
                        // println("Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}")
                        Log.i(
                            TAG,
                            "Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}"
                        )
                        val res=placesList.add("Place '${placeLikelihood.place.name}' of type:'${placeLikelihood.place.types}' has likelihood: ${placeLikelihood.likelihood}")
                        println("Did add: $res")
                    }
                    result.success(placesList)
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

    
//
//public class TaskChecker{
//    public static String getForegroundApplication(Context context){
//        ActivityManager am=(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
//        RunningTaskInfo foreground=am.getRunningTasks(1).get(0);
//        return foreground.topActivity.getPackageName();
//    }
//}

