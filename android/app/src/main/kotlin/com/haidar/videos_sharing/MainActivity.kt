package com.haidar.videos_sharing

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  var channel = "haidar.channel.torrent"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
      if (call.method!!.contentEquals("intent")) {
        result.success(intent.dataString)
      }
    }
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    setIntent(intent)
    recreate()
  }

}
