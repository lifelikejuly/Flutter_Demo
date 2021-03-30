package com.hjapp.flutter_app_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.hjapp.ui.activity.MessengerActivity;
import com.hjapp.ui.activity.WebActivity;

import java.util.HashMap;
import java.util.Map;

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
    private static MethodChannel channel;


    public FlutterAppPlugin(Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "flutter_app_plugin");
        channel.setMethodCallHandler(new FlutterAppPlugin(registrar.activity(), registrar.activeContext()));

    }


    public static void invokeMethod(MethodChannel.Result result) {
        channel.invokeMethod("flutter_app_plugin", "hello", result);
    }

    public static void setMethodCallHandler(MethodChannel.MethodCallHandler handler) {
        channel.setMethodCallHandler(handler);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("goToNativePage")) { //跳转原生Activity入口
            String path = call.argument("router");
            Intent intent = null;
            switch (path) {
                case "web":
                    intent = new Intent(activity, WebActivity.class);
                    activity.startActivity(intent);
                    break;
                case "messenger":
                    intent = new Intent(activity, MessengerActivity.class);
                    activity.startActivity(intent);
                    break;
                case "crash":
                    throw new IllegalStateException("This is Java exception");
                case "testChannel":
                    int value = (int) call.argument("ok");
                    Map<String,String> map = new HashMap<>();
                    if(value == 0){
                        map.put("yes","yes");
                        result.success(map);
                    }else{
                        map.put("yes","no");
                        result.error("-1", "bitmap null", map);
                    }
                    break;
                default:
                    result.notImplemented();
                    break;
            }

        } else if (call.method.equals("testChannel")) { //跳转原生Activity入口
            int value = (int) call.argument("ok");
            Map<String,String> map = new HashMap<>();
            if(value == 0){
                map.put("yes","yes");
                result.success(map);
            }else{
//                result.error("-1", "bitmap null", "sss");
                map.put("yes","no");
                result.error("-1", "bitmap null", map);
            }
        }else {
            result.notImplemented();
        }
    }


    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }
}
