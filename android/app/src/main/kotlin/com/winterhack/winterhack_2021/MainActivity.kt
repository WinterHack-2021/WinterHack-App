package com.winterhack.winterhack_2021

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "blacklist-channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            run {
                println("Hello");
                if (call.method == "disablerEnabler") {
                    val appResult = disablerEnabler()
                    result.success(appResult)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            }
        }
    }

    private fun disablerEnabler(): String {
        return "aOWIUDBIUFB"
    }
}
