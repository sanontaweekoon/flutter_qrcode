package com.codemobiles.my_qrcode

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, "th.share/share").setMethodCallHandler{
      methodCall, result ->
      if(methodCall.method == "shareFile"){
        shareFile(methodCall.arguments as String)
      }
    }
  }

  // add
  private fun shareFile(path: String) {
    val imageFile = File(cacheDir, path)
    val contentUri = FileProvider.getUriForFile(this, "th.qrcode/share", imageFile)
    // cm.qrcode.share (ref. AndroidManifest.xml)

    Intent(Intent.ACTION_SEND).let {
      it.type = "image/png"
      it.putExtra(Intent.EXTRA_STREAM, contentUri)
      startActivity(Intent.createChooser(it, "Share QRCode"))

      Toast.makeText(applicationContext, "ThaiMedia", Toast.LENGTH_LONG).show()
    }

  }
}
