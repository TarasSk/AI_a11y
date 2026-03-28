package com.ai_a11y.ai_a11y

import android.app.Activity
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Bundle

/// Transparent Activity that requests MediaProjection consent (first time only).
///
/// IMPORTANT: getMediaProjection() must NOT be called here — Android requires
/// a running FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION service at the time of
/// that call. So we just forward resultCode + data to CaptureService, which
/// calls getMediaProjection() after startForeground().
///
/// On subsequent taps the stored MediaProjection in OverlayService is reused —
/// no dialog shown and no extras needed.
class ScreenshotActivity : Activity() {

    companion object {
        private const val MEDIA_PROJECTION_REQUEST = 2001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ── Reuse existing projection — skip dialog entirely ──────
        if (OverlayService.instance?.mediaProjection != null) {
            startCaptureService(null, null)
            finish()
            return
        }

        // ── First time: ask for consent ───────────────────────────
        val manager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        val captureIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            // Pre-selects "Share entire screen" on Android 14+.
            manager.createScreenCaptureIntent(
                android.media.projection.MediaProjectionConfig.createConfigForDefaultDisplay()
            )
        } else {
            @Suppress("DEPRECATION")
            manager.createScreenCaptureIntent()
        }
        @Suppress("DEPRECATION")
        startActivityForResult(captureIntent, MEDIA_PROJECTION_REQUEST)
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == MEDIA_PROJECTION_REQUEST && resultCode == RESULT_OK && data != null) {
            // Forward to CaptureService — it calls getMediaProjection() AFTER startForeground().
            startCaptureService(resultCode, data)
        } else {
            OverlayService.instance?.showOverlayButton()
        }

        finish()
    }

    private fun startCaptureService(resultCode: Int?, data: Intent?) {
        val intent = Intent(this, CaptureService::class.java).apply {
            if (resultCode != null && data != null) {
                putExtra("resultCode", resultCode)
                putExtra("data", data)
            }
        }
        startForegroundService(intent)
    }
}
