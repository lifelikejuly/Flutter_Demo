package com.hjapp.flutter_app_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.hjapp.ui.activity.WebActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterAppPlugin
 */
public class FlutterAppPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

    private Activity activity;
    private Context context;

    public FlutterAppPlugin(Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_app_plugin");
        channel.setMethodCallHandler(new FlutterAppPlugin(registrar.activity(), registrar.activeContext()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("goToNativePage")) { //跳转原生Activity入口
            String path = call.argument("router");
            switch (path) {
                case "web":
                    Intent intent = new Intent(activity, WebActivity.class);
                    activity.startActivity(intent);
                    break;
                default:
                    result.notImplemented();
                    break;
            }

        } else {
            result.notImplemented();
        }
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }
}
