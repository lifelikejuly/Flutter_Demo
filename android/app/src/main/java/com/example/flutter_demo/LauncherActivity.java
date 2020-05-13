package com.example.flutter_demo;

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class LauncherActivity extends AppCompatActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterActivity.withNewEngine()
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                .initialRoute("/")
                .build(this);
    }
}
