package com.winterhack.winterhack_2021


import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"


    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        startDisabledAppService()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            run {
                println("CALL NATIVE: ${call.method}")
                when (call.method) {
                    "setDisabledApps" -> {
                        val disabledApps: MutableList<String> = call.arguments();
                        DisablerService.disabledApps = disabledApps
                        println(disabledApps)
                        result.success(true)
                    }
                    "setEnabled" -> {
                        val isEnabled: Boolean = call.arguments();
                        DisablerService.isEnabled = isEnabled
                        println(isEnabled)
                        result.success(true)
                    }
                    // Return (single string) settings user needs, or null
                    "getNeededPermission" -> {
                        result.success(getNeededPermission()?.friendlyName)
                    }
                    "openNeededSettings" -> {
                        openNeededSettings()
                        result.success(true)
                    }
                    else -> {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getNeededPermission(): NeededSettings? {
        // println("USAGEEE " + DisablerService.getForegroundProcess(this));
        if (DisablerService.getForegroundProcess(this) == null) {
            return NeededSettings.USAGE_STATS
        } else if (!Settings.canDrawOverlays(this)) {
            return NeededSettings.DRAW_OVER_APPS
        } else if (ActivityCompat.checkSelfPermission(
                this,
                android.Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return NeededSettings.LOCATION
        } else if (ActivityCompat.checkSelfPermission(
                this,
                android.Manifest.permission.ACTIVITY_RECOGNITION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return NeededSettings.PHYSICAL_ACTIVITY
        }
        return null
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun openNeededSettings() {
        val neededPermission = getNeededPermission() ?: return
        Log.d(TAG, "Asking for permission: $neededPermission")
        when (neededPermission) {
            NeededSettings.DRAW_OVER_APPS -> {
                startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION));
            }
            NeededSettings.LOCATION -> {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        android.Manifest.permission.ACCESS_COARSE_LOCATION,
                        android.Manifest.permission.ACCESS_FINE_LOCATION,
                        android.Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    ),
                    0
                );
            }
            NeededSettings.USAGE_STATS -> {
                startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS));
            }
            NeededSettings.PHYSICAL_ACTIVITY -> {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        android.Manifest.permission.ACTIVITY_RECOGNITION,
                    ),
                    1
                )
            }
        }

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun startDisabledAppService() {
        val intent = Intent(this, DisablerService::class.java)
        startService(intent)
    }

    companion object {
        @JvmStatic
        val TAG = MainActivity::class.java.simpleName

    }
}

