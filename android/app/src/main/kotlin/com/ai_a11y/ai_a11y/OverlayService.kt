package com.ai_a11y.ai_a11y

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.content.pm.ServiceInfo
import android.media.projection.MediaProjection
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import androidx.core.app.NotificationCompat

/// Foreground service that shows a draggable floating button overlay.
/// Does NOT use MediaProjection — screenshot capture is delegated to
/// ScreenshotActivity → CaptureService per tap.
class OverlayService : Service() {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null

    companion object {
        private const val NOTIFICATION_CHANNEL_ID = "overlay_service_channel"
        private const val NOTIFICATION_ID = 1001

        /// Static reference so CaptureService can show/hide the button.
        var instance: OverlayService? = null
    }

    // ─── MediaProjection storage ──────────────────────────────────

    var mediaProjection: MediaProjection? = null
        private set

    private val projectionCallback = object : MediaProjection.Callback() {
        override fun onStop() {
            mediaProjection = null
        }
    }

    /** Store a fresh MediaProjection and register the required callback. */
    fun setMediaProjection(projection: MediaProjection) {
        mediaProjection?.unregisterCallback(projectionCallback)
        mediaProjection = projection
        projection.registerCallback(projectionCallback, Handler(Looper.getMainLooper()))
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            stopSelf()
            return START_NOT_STICKY
        }

        createNotificationChannel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                createNotification(),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
            )
        } else {
            startForeground(NOTIFICATION_ID, createNotification())
        }
        showOverlay()

        return START_STICKY
    }

    // ─── Notification ─────────────────────────────────────────────

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            "Screenshot Overlay",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Keeps the screenshot overlay running"
        }
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)
    }

    private fun createNotification(): Notification {
        val stopIntent = Intent(this, OverlayService::class.java).apply {
            action = "STOP"
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("AI A11Y")
            .setContentText("Screenshot overlay is active. Tap the floating button to capture.")
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Stop",
                stopPendingIntent
            )
            .build()
    }

    // ─── Overlay View ─────────────────────────────────────────────

    private fun showOverlay() {
        if (!Settings.canDrawOverlays(this)) return

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val density = resources.displayMetrics.density
        val size = (64 * density).toInt()

        val button = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_menu_camera)
            setColorFilter(android.graphics.Color.WHITE)
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(0xFF6200EE.toInt())
                setStroke((2 * density).toInt(), 0xFFFFFFFF.toInt())
            }
            val padding = (16 * density).toInt()
            setPadding(padding, padding, padding, padding)
            scaleType = ImageView.ScaleType.FIT_CENTER
        }

        val params = WindowManager.LayoutParams(
            size, size,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0
            y = (200 * density).toInt()
        }

        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        var moved = false

        button.setOnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    moved = false
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - initialTouchX
                    val dy = event.rawY - initialTouchY
                    if (dx * dx + dy * dy > 100) moved = true
                    params.x = initialX + dx.toInt()
                    params.y = initialY + dy.toInt()
                    windowManager?.updateViewLayout(view, params)
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (!moved) {
                        onScreenshotButtonTapped()
                    }
                    true
                }
                else -> false
            }
        }

        overlayView = button
        windowManager?.addView(overlayView, params)
    }

    // ─── Screenshot trigger ───────────────────────────────────────

    private fun onScreenshotButtonTapped() {
        hideOverlayButton()

        // Wait for the window manager to commit the visibility change before capturing,
        // otherwise the floating button may still appear in the screenshot.
        Handler(Looper.getMainLooper()).postDelayed({
            if (ScreenCaptureAccessibilityService.isAvailable && Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                // Silent capture — no dialog at all.
                ScreenCaptureAccessibilityService.instance?.captureScreen {
                    showOverlayButton()
                }
            } else {
                // Fallback: MediaProjection (shows consent dialog once, then reuses token).
                val intent = Intent(this, ScreenshotActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
            }
        }, 300)
    }

    fun showOverlayButton() {
        overlayView?.visibility = View.VISIBLE
    }

    fun hideOverlayButton() {
        overlayView?.visibility = View.INVISIBLE
    }

    // ─── Cleanup ──────────────────────────────────────────────────

    override fun onDestroy() {
        super.onDestroy()
        instance = null
        mediaProjection?.stop()
        mediaProjection = null
        overlayView?.let {
            try { windowManager?.removeView(it) } catch (_: Exception) {}
        }
        overlayView = null
    }
}
