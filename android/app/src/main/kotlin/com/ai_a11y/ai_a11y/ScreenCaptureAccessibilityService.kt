package com.ai_a11y.ai_a11y

import android.accessibilityservice.AccessibilityService
import android.content.ContentValues
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.view.Display
import android.view.accessibility.AccessibilityEvent
import android.widget.Toast
import androidx.annotation.RequiresApi
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.Executors

/// Accessibility Service that captures the screen silently — no system dialog required.
/// User enables it once via Settings > Accessibility > AI A11Y.
///
/// Requires API 30 (Android 11+). Falls back to MediaProjection flow on older devices.
class ScreenCaptureAccessibilityService : AccessibilityService() {

    companion object {
        var instance: ScreenCaptureAccessibilityService? = null

        /** True when the service is running and the device supports takeScreenshot(). */
        val isAvailable: Boolean
            get() = instance != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    }

    // ─── Lifecycle ────────────────────────────────────────────────

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onUnbind(intent: Intent?): Boolean {
        instance = null
        return super.onUnbind(intent)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    // ─── Screenshot ───────────────────────────────────────────────

    @RequiresApi(Build.VERSION_CODES.R)
    fun captureScreen(onDone: () -> Unit) {
        takeScreenshot(
            Display.DEFAULT_DISPLAY,
            Executors.newSingleThreadExecutor(),
            object : TakeScreenshotCallback {
                override fun onSuccess(screenshot: ScreenshotResult) {
                    val bitmap = Bitmap.wrapHardwareBuffer(
                        screenshot.hardwareBuffer,
                        screenshot.colorSpace
                    )?.copy(Bitmap.Config.ARGB_8888, false)
                    screenshot.hardwareBuffer.close()

                    if (bitmap != null) {
                        val uri = saveBitmapToMediaStore(bitmap)
                        bitmap.recycle()
                        Handler(Looper.getMainLooper()).post {
                            if (uri != null) openScreenshot(uri)
                            else toast("Screenshot saved to Pictures/AI_A11Y")
                            onDone()
                        }
                    } else {
                        Handler(Looper.getMainLooper()).post {
                            toast("Screenshot failed: empty image")
                            onDone()
                        }
                    }
                }

                override fun onFailure(errorCode: Int) {
                    Handler(Looper.getMainLooper()).post {
                        toast("Screenshot failed (code $errorCode)")
                        onDone()
                    }
                }
            }
        )
    }

    // ─── Save to MediaStore ────────────────────────────────────────

    private fun saveBitmapToMediaStore(bitmap: Bitmap): Uri? {
        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, "screenshot_$timestamp.png")
            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
            put(
                MediaStore.Images.Media.RELATIVE_PATH,
                "${Environment.DIRECTORY_PICTURES}/AI_A11Y"
            )
        }
        return try {
            val uri = contentResolver.insert(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues
            )
            uri?.let {
                contentResolver.openOutputStream(it)?.use { stream ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                }
            }
            uri
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    // ─── Open image viewer ────────────────────────────────────────

    private fun openScreenshot(uri: Uri) {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "image/png")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            startActivity(intent)
        } catch (_: Exception) {
            toast("Screenshot saved to Pictures/AI_A11Y")
        }
    }

    // ─── Helpers ──────────────────────────────────────────────────

    private fun toast(msg: String) =
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
}

