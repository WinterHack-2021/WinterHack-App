package com.winterhack.winterhack_2021


import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "winterhack-channel"


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
                    else -> {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
            }
        }
    }

    private fun startDisabledAppService() {
        // val pendingIntent: PendingIntent?
        // val alarmManager: AlarmManager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, DisablerService::class.java)
        //pendingIntent = PendingIntent.getService(this, 5, intent, 0)
        startService(intent)
        //alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, 5000, 100000, pendingIntent)
    }

    companion object {
        @JvmStatic
        val TAG = MainActivity::class.java.simpleName

    }
}

