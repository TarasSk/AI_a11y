package com.ai_a11y.ai_a11y

import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.media.ImageReader
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.DisplayMetrics
import android.view.WindowManager
import android.widget.Toast
import android.hardware.display.DisplayManager
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/// Short-lived foreground service that captures a single screenshot
/// via MediaProjection, saves it, and stops itself.
class CaptureService : Service() {

    companion object {
        private const val NOTIFICATION_CHANNEL_ID = "capture_service_channel"
        private const val NOTIFICATION_ID = 2001
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val resultCode = intent?.getIntExtra("resultCode", Activity.RESULT_CANCELED)
            ?: Activity.RESULT_CANCELED

        @Suppress("DEPRECATION")
        val resultData = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent?.getParcelableExtra("data", Intent::class.java)
        } else {
            intent?.getParcelableExtra("data")
        }

        createNotificationChannel()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                createNotification(),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
            )
        } else {
            startForeground(NOTIFICATION_ID, createNotification())
        }

        // Delay so ScreenshotActivity has time to fully disappear from screen
        Handler(Looper.getMainLooper()).postDelayed({
            captureScreen(resultCode, resultData)
        }, 300)

        return START_NOT_STICKY
    }

    // ─── Notification ─────────────────────────────────────────────

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            "Screenshot Capture",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Taking a screenshot"
        }
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("AI A11Y")
            .setContentText("Capturing screenshot…")
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    // ─── Capture ──────────────────────────────────────────────────

    @Suppress("DEPRECATION")
    private fun captureScreen(resultCode: Int, resultData: Intent?) {
        if (resultCode != Activity.RESULT_OK || resultData == null) {
            finish()
            return
        }

        try {
            val manager = getSystemService(Context.MEDIA_PROJECTION_SERVICE)
                    as MediaProjectionManager
            val mediaProjection = manager.getMediaProjection(resultCode, resultData)
                ?: run { finish(); return }

            val metrics = DisplayMetrics()
            val wm = getSystemService(Context.WINDOW_SERVICE) as WindowManager
            @Suppress("DEPRECATION")
            wm.defaultDisplay.getRealMetrics(metrics)

            val width = metrics.widthPixels
            val height = metrics.heightPixels
            val density = metrics.densityDpi

            val imageReader = ImageReader.newInstance(width, height, PixelFormat.RGBA_8888, 2)

            val virtualDisplay = mediaProjection.createVirtualDisplay(
                "ScreenCapture",
                width, height, density,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                imageReader.surface,
                null, null
            ) ?: run {
                imageReader.close()
                mediaProjection.stop()
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
                    mediaProjection.stop()
                    finish()
                    return@setOnImageAvailableListener
                }

                try {
                    val planes = image.planes
                    val buffer = planes[0].buffer
                    val pixelStride = planes[0].pixelStride
                    val rowStride = planes[0].rowStride
                    val rowPadding = rowStride - pixelStride * width

                    val bitmap = Bitmap.createBitmap(
                        width + rowPadding / pixelStride,
                        height,
                        Bitmap.Config.ARGB_8888
                    )
                    bitmap.copyPixelsFromBuffer(buffer)

                    val croppedBitmap = if (rowPadding > 0) {
                        Bitmap.createBitmap(bitmap, 0, 0, width, height).also {
                            bitmap.recycle()
                        }
                    } else {
                        bitmap
                    }

                    val path = saveBitmap(croppedBitmap)
                    croppedBitmap.recycle()

                    Handler(Looper.getMainLooper()).post {
                        Toast.makeText(this@CaptureService, "Screenshot saved: $path", Toast.LENGTH_SHORT).show()
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    Handler(Looper.getMainLooper()).post {
                        Toast.makeText(this@CaptureService, "Screenshot failed: ${e.message}", Toast.LENGTH_SHORT).show()
                    }
                } finally {
                    image.close()
                    reader.close()
                    mediaProjection.stop()
                    finish()
                }
            }, Handler(Looper.getMainLooper()))

        } catch (e: Exception) {
            e.printStackTrace()
            Handler(Looper.getMainLooper()).post {
                Toast.makeText(this, "Screenshot error: ${e.message}", Toast.LENGTH_SHORT).show()
            }
            finish()
        }
    }

    // ─── Save ─────────────────────────────────────────────────────

    private fun saveBitmap(bitmap: Bitmap): String {
        val dir = File(
            getExternalFilesDir(Environment.DIRECTORY_PICTURES),
            "screenshots"
        )
        dir.mkdirs()

        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val file = File(dir, "screenshot_$timestamp.png")

        FileOutputStream(file).use { out ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
        }

        return file.absolutePath
    }

    // ─── Cleanup ──────────────────────────────────────────────────

    private fun finish() {
        Handler(Looper.getMainLooper()).post {
            OverlayService.instance?.showOverlayButton()
        }
        stopSelf()
    }
}

