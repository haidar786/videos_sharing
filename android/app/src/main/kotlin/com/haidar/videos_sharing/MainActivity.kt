package com.haidar.videos_sharing

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson
import java.io.File

class MainActivity: FlutterActivity() {
  var channel = "haidar.channel.torrent"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
   // val gson = Gson()
  //  val pair = Pair(first = intent.dataString,second = intent.data?.path)

    MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
      if (call.method.contentEquals("intent")) {
        result.success(intent.dataString)
      }
    }
  }

//  override fun onNewIntent(intent: Intent) {
//    super.onNewIntent(intent)
//    setIntent(intent)
//    recreate()
//  }

}
