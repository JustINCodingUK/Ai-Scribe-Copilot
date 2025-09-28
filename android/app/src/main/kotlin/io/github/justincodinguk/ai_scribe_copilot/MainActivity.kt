package io.github.justincodinguk.ai_scribe_copilot

import android.Manifest
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put("main", flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "io.github.justincodinguk.ai_scribe_copilot/MicController")
            .setMethodCallHandler { call, result ->
                if(call.method == "startRecording") {
                    val intent = Intent(this, MicService::class.java)
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }
            }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(
                arrayOf(
                    Manifest.permission.READ_PHONE_STATE,
                    Manifest.permission.RECORD_AUDIO
                ),
                0
            )
        }
    }
}
