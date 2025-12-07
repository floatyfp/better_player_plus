package uz.shs.better_player_example

import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import uz.shs.better_player_plus.BetterPlayerPlugin

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startNotificationService()
    }

    override fun onPictureInPictureModeChanged(active: Boolean, newConfig: Configuration) {
        super.onPictureInPictureModeChanged(active, newConfig)
        BetterPlayerPlugin.onPictureInPictureModeChanged(active)
    }

    override fun onDestroy() {
        super.onDestroy()
        stopNotificationService()
    }

    ///TODO: Call this method via channel after remote notification start
    private fun startNotificationService() {
        try {
            val intent = Intent(this, BetterPlayerService::class.java)
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
        } catch (_: Exception) {
        }
    }

    ///TODO: Call this method via channel after remote notification stop
    private fun stopNotificationService() {
        try {
            val intent = Intent(this, BetterPlayerService::class.java)
            stopService(intent)
        } catch (_: Exception) {

        }
    }
}
