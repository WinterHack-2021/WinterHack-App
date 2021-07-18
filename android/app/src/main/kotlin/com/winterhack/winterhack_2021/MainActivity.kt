package com.winterhack.winterhack_2021

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.ActivityManager.RunningTaskInfo

import android.content.Context
import android.app.ActivityManager


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
        return "Suuup";
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

