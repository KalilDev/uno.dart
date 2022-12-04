package com.example.app

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity: FlutterActivity() {
    override  fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen();
        super.onCreate(savedInstanceState);
    }
}
