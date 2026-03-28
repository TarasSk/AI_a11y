package com.ai_a11y.ai_a11y

import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.hardware.display.DisplayManager
import android.media.ImageReader
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.MediaStore
import android.util.DisplayMetrics
import android.view.WindowManager
import android.widget.Toast
import androidx.core.app.NotificationCompat

/// Short-lived foreground service that captures a single screenshot,
/// saves it to the public Pictures gallery, and opens the system image viewer.
class CaptureService : Service() {

    companion object {
        private const val NOTIFICATION_CHANNEL_ID = "capture_service_channel"
        private const val NOTIFICATION_ID = 2001
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()

        // 1️⃣ Start foreground with MEDIA_PROJECTION type FIRST.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                createNotification(),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
            )
        } else {
            startForeground(NOTIFICATION_ID, createNotification())
        }

        // 2️⃣ If no stored projection, create one NOW (safe — foreground is running).
        if (OverlayService.instance?.mediaProjection == null) {
            val resultCode = intent?.getIntExtra("resultCode", Activity.RESULT_CANCELED)
                ?: Activity.RESULT_CANCELED
            @Suppress("DEPRECATION")
            val resultData = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent?.getParcelableExtra("data", Intent::class.java)
            } else {
                intent?.getParcelableExtra("data")
            }

            if (resultCode == Activity.RESULT_OK && resultData != null) {
                val manager = getSystemService(Context.MEDIA_PROJECTION_SERVICE)
                        as MediaProjectionManager
                val projection = manager.getMediaProjection(resultCode, resultData)
                if (projection != null) {
                    // registerCallback() is called inside setMediaProjection().
                    OverlayService.instance?.setMediaProjection(projection)
                }
            }
        }

        // Button was already hidden in OverlayService (300ms ago) — capture immediately.
        Handler(Looper.getMainLooper()).post { captureScreen() }

        return START_NOT_STICKY
    }

    // ─── Notification ─────────────────────────────────────────────

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            "Screenshot Capture",
            NotificationManager.IMPORTANCE_LOW
        ).apply { description = "Taking a screenshot" }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }

    private fun createNotification(): Notification =
        NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("AI A11Y")
            .setContentText("Capturing screenshot…")
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

    // ─── Capture ──────────────────────────────────────────────────

    @Suppress("DEPRECATION")
    private fun captureScreen() {
        val mediaProjection = OverlayService.instance?.mediaProjection
        if (mediaProjection == null) {
            showToast("No active screen permission — tap the button again.")
            finish()
            return
        }

        try {
            val metrics = DisplayMetrics()
            val wm = getSystemService(WINDOW_SERVICE) as WindowManager
            wm.defaultDisplay.getRealMetrics(metrics)

            val width   = metrics.widthPixels
            val height  = metrics.heightPixels
            val density = metrics.densityDpi

            val imageReader = ImageReader.newInstance(width, height, PixelFormat.RGBA_8888, 2)

            // Callback was registered in OverlayService.setMediaProjection() — no crash.
            val virtualDisplay = mediaProjection.createVirtualDisplay(
                "ScreenCapture",
                width, height, density,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                imageReader.surface,
                null, null
            ) ?: run {
                imageReader.close()
                showToast("Failed to start screen capture.")
                finish()
                return
            }

            var captured = false

            imageReader.setOnImageAvailableListener({ reader ->
                if (captured) return@setOnImageAvailableListener
                captured = true

                reader.setOnImageAvailableListener(null, null)
                virtualDisplay.release()

                val image = reader.acquireLatestImage()
                if (image == null) {
                    reader.close()
                    finish()
                    return@setOnImageAvailableListener
                }

                try {
                    val planes      = image.planes
                    val buffer      = planes[0].buffer
                    val pixelStride = planes[0].pixelStride
                    val rowStride   = planes[0].rowStride
                    val rowPadding  = rowStride - pixelStride * width

                    val bitmap = Bitmap.createBitmap(
                        width + rowPadding / pixelStride,
                        height,
                        Bitmap.Config.ARGB_8888
                    )
                    bitmap.copyPixelsFromBuffer(buffer)

                    val finalBitmap = if (rowPadding > 0) {
                        Bitmap.createBitmap(bitmap, 0, 0, width, height).also { bitmap.recycle() }
                    } else {
                        bitmap
                    }

                    val uri = saveBitmapToMediaStore(finalBitmap)
                    finalBitmap.recycle()

                    Handler(Looper.getMainLooper()).post {
                        if (uri != null) openScreenshot(uri)
                        else showToast("Screenshot saved to Pictures/AI_A11Y")
                        finish()
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    Handler(Looper.getMainLooper()).post {
                        showToast("Screenshot failed: ${e.message}")
                        finish()
                    }
                } finally {
                    image.close()
                    reader.close()
                    // Do NOT call mediaProjection.stop() — keep alive for reuse.
                }
            }, Handler(Looper.getMainLooper()))

        } catch (e: Exception) {
            e.printStackTrace()
            showToast("Screenshot error: ${e.message}")
            finish()
        }
    }

    // ─── Save to MediaStore ────────────────────────────────────────

    private fun saveBitmapToMediaStore(bitmap: Bitmap): Uri? {
        val timestamp = java.text.SimpleDateFormat("yyyyMMdd_HHmmss", java.util.Locale.getDefault())
            .format(java.util.Date())

        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, "screenshot_$timestamp.png")
            put(MediaStore.Images.Media.MIME_TYPE,    "image/png")
            put(MediaStore.Images.Media.RELATIVE_PATH,
                "${Environment.DIRECTORY_PICTURES}/AI_A11Y")
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

    // ─── Open screenshot ──────────────────────────────────────────

    private fun openScreenshot(uri: Uri) {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "image/png")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            startActivity(intent)
        } catch (_: Exception) {
            showToast("Screenshot saved to Pictures/AI_A11Y")
        }
    }

    // ─── Helpers ──────────────────────────────────────────────────

    private fun showToast(msg: String) =
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()

    private fun finish() {
        Handler(Looper.getMainLooper()).post {
            OverlayService.instance?.showOverlayButton()
        }
        stopSelf()
    }
}
