package com.ai_a11y.ai_a11y

import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.ai_a11y/overlay"
        private const val OVERLAY_PERMISSION_REQUEST = 1000
        private var methodChannel: MethodChannel? = null

        fun notifyScreenshotCaptured(screenshotPath: String) {
            methodChannel?.invokeMethod("onScreenshotCaptured", screenshotPath)
        }
    }

    private var pendingOverlayResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasOverlayPermission" -> {
                        result.success(Settings.canDrawOverlays(this))
                    }

                    "requestOverlayPermission" -> {
                        if (Settings.canDrawOverlays(this)) {
                            result.success(true)
                        } else {
                            pendingOverlayResult = result
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            )
                            @Suppress("DEPRECATION")
                            startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST)
                        }
                    }

                    "startOverlay" -> {
                        val intent = Intent(this, OverlayService::class.java)
                        startForegroundService(intent)
                        result.success(true)
                    }

                    "stopOverlay" -> {
                        stopService(Intent(this, OverlayService::class.java))
                        result.success(true)
                    }

                    "hasAccessibilityPermission" -> {
                        result.success(isAccessibilityServiceEnabled())
                    }

                    "requestAccessibilityPermission" -> {
                        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success(false)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ─── Helpers ──────────────────────────────────────────────────

    private fun isAccessibilityServiceEnabled(): Boolean {
        val flat = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false
        val component = ComponentName(this, ScreenCaptureAccessibilityService::class.java)
        return flat.split(':').any { it.equals(component.flattenToString(), ignoreCase = true) }
    }

    // ─── Activity result ──────────────────────────────────────────

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == OVERLAY_PERMISSION_REQUEST) {
            pendingOverlayResult?.success(Settings.canDrawOverlays(this))
            pendingOverlayResult = null
        }
    }
}
