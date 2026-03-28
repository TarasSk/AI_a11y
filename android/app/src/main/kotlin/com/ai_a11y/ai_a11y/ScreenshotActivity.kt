package com.ai_a11y.ai_a11y

import android.app.Activity
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Bundle

/// Transparent Activity that requests MediaProjection consent and
/// delegates actual capture to [CaptureService].
/// Visible only briefly (system consent dialog), then finishes.
class ScreenshotActivity : Activity() {

    companion object {
        private const val MEDIA_PROJECTION_REQUEST = 2001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val manager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        @Suppress("DEPRECATION")
        startActivityForResult(manager.createScreenCaptureIntent(), MEDIA_PROJECTION_REQUEST)
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == MEDIA_PROJECTION_REQUEST && resultCode == RESULT_OK && data != null) {
            // User approved — start short-lived CaptureService
            val intent = Intent(this, CaptureService::class.java).apply {
                putExtra("resultCode", resultCode)
                putExtra("data", data)
            }
            startForegroundService(intent)
        } else {
            // User denied — show overlay button again
            OverlayService.instance?.showOverlayButton()
        }

        finish()
    }
}

