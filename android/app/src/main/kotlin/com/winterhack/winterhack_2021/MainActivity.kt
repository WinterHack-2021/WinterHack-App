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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            run {
                when (call.method) {
                    "setDisabledApps"->{
                        val disabledApps: MutableList<String> = call.arguments();
                        setDisabledApps(disabledApps);
                        println(disabledApps)
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

    companion object {
        private val TAG = MainActivity::class.java.simpleName

    }
}

