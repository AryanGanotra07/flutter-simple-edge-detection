package com.codingee.gst.invoice.scanner.ai.report

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.plugins.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService


class Application : FlutterApplication(), PluginRegistrantCallback {
    // ...
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: io.flutter.plugin.common.PluginRegistry?) {
        registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
    }
}