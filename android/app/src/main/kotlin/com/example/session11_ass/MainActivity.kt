package com.example.session11_ass

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity : FlutterActivity() {

    private val CHANNEL = "cyberlog/device"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "getDeviceModel" ->
                    result.success(Build.MODEL)

                "getManufacturer" ->
                    result.success(Build.MANUFACTURER)

                "getBrand" ->
                    result.success(Build.BRAND)

                "getDeviceCodeName" ->
                    result.success(Build.DEVICE)

                // ✅ ANDROID VERSION (13, 14, etc.)
                "getAndroidVersion" ->
                    result.success(Build.VERSION.RELEASE)

                // ✅ SDK LEVEL (33, 34, etc.)
                "getSdkLevel" ->
                    result.success(Build.VERSION.SDK_INT)

                "getSecurityPatch" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        result.success(Build.VERSION.SECURITY_PATCH)
                    } else {
                        result.success("Unavailable")
                    }
                }

                "getBuildFingerprint" ->
                    result.success(Build.FINGERPRINT)

                else ->
                    result.notImplemented()
            }
        }
    }
}
