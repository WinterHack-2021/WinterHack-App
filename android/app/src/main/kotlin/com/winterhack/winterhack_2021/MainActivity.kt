package com.winterhack.winterhack_2021


import android.Manifest.permission
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import com.google.android.gms.common.api.ApiException
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.model.PlaceLikelihood
import com.google.android.libraries.places.api.net.FindCurrentPlaceRequest
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //GeneratedPluginRegistrant.registerWith(flutterEngine)
        startDisablerService()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            run {
                when (call.method) {
                    "setDisabledApps"->{
                        val disabledApps: List<String> = call.arguments();
                        setDisabledApps(disabledApps)
                        println(disabledApps)
                    }
                    "getcurrentlocation" -> {
                        getcurrentlocation(result)
                    }
                    else -> {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
            }
        }
    }

    private fun setDisabledApps(disabledApps: List<String>) {
        val pendingIntent: PendingIntent?
        val alarmManager: AlarmManager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(this, AlertReceiver::class.java)
        intent.putStringArrayListExtra(AlertReceiver.DISABLED_APPS_INPUT_KEY, ArrayList(disabledApps))

        pendingIntent = PendingIntent.getBroadcast(this, 5, intent, 0)
        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, 5000, 100000, pendingIntent)
    }

    private fun startDisablerService(): Intent {
        val forService = Intent(this@MainActivity, MyService::class.java);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(forService)
        } else {
            startService(forService)
        }
        return forService;
    }


    private fun getcurrentlocation(result: MethodChannel.Result) {
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

