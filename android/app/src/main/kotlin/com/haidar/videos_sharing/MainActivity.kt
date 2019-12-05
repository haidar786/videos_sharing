package com.haidar.videos_sharing

import android.content.Context
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import android.media.AudioManager
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  var channel = "haidar.channel.torrent"
  var volumeChannel = "haidar.channel.volume"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
      if (call.method!!.contentEquals("intent")) {
        result.success(intent.dataString)
      }
    }
    MethodChannel(flutterView,volumeChannel).setMethodCallHandler { call, result ->
      when (call.method) {
        "muteMode" -> result.success(muteMode)
        "volume" -> result.success(volume)
        "setMaxVolume" -> setMaxVolume()
        "setVolume" -> {
          var vol = 1.0
          if( call.hasArgument("volume")){
            vol = call.argument<Double>("volume")!!.toDouble()
          }
          setVolume(vol)
        }
        "mute" -> setMinVolume()
      }
    }
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    setIntent(intent)
    recreate()
  }

  private fun setVolume(volume: Double) {
    val am = (applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager)
    val maxValue = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
    am.setStreamVolume(AudioManager.STREAM_MUSIC, (maxValue * volume + 0.5).toInt(), 0)
  }

  private fun setMaxVolume() {
    val am = (applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager)
    am.setStreamVolume(AudioManager.STREAM_MUSIC, am.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0)
  }

  private fun setMinVolume() {
    val am = applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    am.setStreamVolume(AudioManager.STREAM_MUSIC, 0, 0)
  }

  private val volume: Double
    get() {
      val am = applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
      val maxValue = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toDouble()
      return am.getStreamVolume(AudioManager.STREAM_MUSIC) / maxValue
    }

  private val muteMode: Int
    get() {
      val am = applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
      return am.ringerMode
    }

}
