package com.hjapp.flutter_app_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.Surface;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.Request;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.SizeReadyCallback;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.hjapp.ui.activity.MessengerActivity;
import com.hjapp.ui.activity.WebActivity;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.TextureRegistry;

/**
 * FlutterAppPlugin
 */
public class FlutterAppPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

    private Activity activity;
    private Context context;
    private static MethodChannel channel;

    private LinkedList<TextureRegistry.SurfaceTextureEntry> textureSurfaces = new LinkedList<>();
    private final Registrar registrar;

    public FlutterAppPlugin(Registrar registrar, Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "flutter_app_plugin");
        channel.setMethodCallHandler(new FlutterAppPlugin(registrar, registrar.activity(), registrar.activeContext()));
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
                default:
                    result.notImplemented();
                    break;
            }

        } else if (call.method.equals("loadTextureId")) {
            loadTextureId(result);
        } else if (call.method.equals("loadTextureUrl")) {
            loadTextureImage(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void loadTextureId(Result result) {
        TextureRegistry textureRegistry = registrar.textures();
        Map<String, Object> reply = new HashMap<>();
        if (textureSurfaces.size() == 30) {
            TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = textureSurfaces.removeFirst();
            reply.put("textureId", surfaceTextureEntry.id());
            textureSurfaces.add(surfaceTextureEntry);
        } else {
            TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = textureRegistry.createSurfaceTexture();
            long textureId = surfaceTextureEntry.id();
            reply.put("textureId", textureId);
            textureSurfaces.addLast(surfaceTextureEntry);
        }
        result.success(reply);
    }

    private void loadTextureImage(MethodCall call, final Result result) {
        int textureId = call.argument("textureId");
        final String url = call.argument("url");
        TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = null;
        for (TextureRegistry.SurfaceTextureEntry entry : textureSurfaces) {
            if (entry.id() == textureId) {
                surfaceTextureEntry = entry;
                break;
            }
        }
        if (surfaceTextureEntry != null) {
            Map<String, Object> reply = new HashMap<>();
            reply.put("textureId", surfaceTextureEntry.id());
            loadImage(reply, result, url, surfaceTextureEntry);
        } else {
            TextureRegistry textureRegistry = registrar.textures();
            Map<String, Object> reply = new HashMap<>();
            if (textureSurfaces.size() == 30) {
                surfaceTextureEntry = textureSurfaces.removeFirst();
                reply.put("textureId", surfaceTextureEntry.id());
                textureSurfaces.add(surfaceTextureEntry);
            } else {
                surfaceTextureEntry = textureRegistry.createSurfaceTexture();
                reply.put("textureId", surfaceTextureEntry.id());
                textureSurfaces.addLast(surfaceTextureEntry);
            }
            loadImage(reply, result, url, surfaceTextureEntry);
        }
    }

    private void loadImage(final Map<String, Object> maps, final Result result, String url, final TextureRegistry.SurfaceTextureEntry surfaceTextureEntry) {



        Glide.with(context).asBitmap().load(url).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                return false;
            }

            @Override
            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                Log.i("loadImage", "onResourceReady " + surfaceTextureEntry.id());
                Rect rect = new Rect(0, 0, 100, 100);
                surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(resource.getWidth(), resource.getHeight());
                Surface surface = new Surface(surfaceTextureEntry.surfaceTexture());
                Canvas canvas = surface.lockCanvas(rect);
                canvas.drawBitmap(resource, null, rect, null);
                surface.unlockCanvasAndPost(canvas);
                maps.put("textureId", surfaceTextureEntry.id());
                if(activity != null){
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(maps);
                        }
                    });
                }
                return false;
            }
        }).submit();
    }

    private void loadTextureGif(MethodCall call, Result result) {
        int textureId = call.argument("textureId");
        final String url = call.argument("url");
        Bitmap bitmap = BitmapFactory.decodeResource(this.context.getResources(), R.drawable.jay);
        int imageWidth = bitmap.getWidth();
        int imageHeight = bitmap.getHeight();
        TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = null;
        for (TextureRegistry.SurfaceTextureEntry entry : textureSurfaces) {
            if (entry.id() == textureId) {
                surfaceTextureEntry = entry;
                break;
            }
        }
        if (surfaceTextureEntry == null) {
            result.success(-1);
            return;
        }
        Rect rect = new Rect(0, 0, 100, 100);
        surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(imageWidth, imageHeight);
        Surface surface = new Surface(surfaceTextureEntry.surfaceTexture());
        Canvas canvas = surface.lockCanvas(rect);
        canvas.drawBitmap(bitmap, null, rect, null);
        bitmap.recycle();
        surface.unlockCanvasAndPost(canvas);
        result.success(0);

    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }
}
