package com.julyyu.external_texture_plugin;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.Surface;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;

/**
 * @author julyyu
 * @date 2020-06-02.
 * description：
 */
public class ExternalTexturePlugin implements MethodChannel.MethodCallHandler {


    private Activity activity;
    private Context context;
    private static MethodChannel channel;
    private HashMap<String,TextureRegistry.SurfaceTextureEntry> textureSurfaces = new HashMap<>();


    private final PluginRegistry.Registrar registrar;


    public ExternalTexturePlugin(PluginRegistry.Registrar registrar, Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
        this.registrar = registrar;
        Log.i("ExternalTexturePlugin", "ExternalTexturePlugin");
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        Log.i("ExternalTexturePlugin", "registerWith");
        channel = new MethodChannel(registrar.messenger(), "external_textrure_plugin");
        channel.setMethodCallHandler(new ExternalTexturePlugin(registrar, registrar.activity(), registrar.activeContext()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        if (methodCall.method.equals("loadUrl")) {
            loadTextureImage(methodCall,result);
        } else if (methodCall.method.equals("release")) {
            release(methodCall,result);
        } else {
            result.notImplemented();
        }
    }

    /**
     * 释放
     * @param call
     * @param result
     */
    private  void release(
            MethodCall call,
            MethodChannel.Result result) {
        String url = call.argument("url");
        if (TextUtils.isEmpty(url)) {
            Map<String, Object> maps = new HashMap<>();
            result.error("error", "url is null", maps);
            return;
        }
        try {
            TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = textureSurfaces.remove(url);
            if (surfaceTextureEntry != null) {
                //TODO 回收时怎么处理
                surfaceTextureEntry.release();
                result.success("1");
            } else {
                result.success("0");
            }
        } catch (Exception e) {
            result.error("error", "relese fail", "");
        }


    }

    /**
     * 加载图片
     *
     * @param call
     * @param result
     */
    private void loadTextureImage(MethodCall call, final MethodChannel.Result result) {
        // 默认textureId为空
//        int textureId = call.argument("textureId");
        final String url = call.argument("url");
        TextureRegistry.SurfaceTextureEntry surfaceTextureEntry  = textureSurfaces.get(url);
        //不为空获取到textureId加载图片
        if (surfaceTextureEntry != null) {
            Map<String, Object> reply = new HashMap<>();
            reply.put("textureId", surfaceTextureEntry.id());
            loadImage(reply, result, url, surfaceTextureEntry);
        } else {
            //textureId空则新建surfaceTextureEntry然后加载图片

            TextureRegistry textureRegistry = registrar.textures();
            surfaceTextureEntry = textureRegistry.createSurfaceTexture();
            Map<String, Object> reply = new HashMap<>();
            reply.put("textureId", surfaceTextureEntry.id());
            textureSurfaces.put(url,surfaceTextureEntry);
            loadImage(reply, result, url, surfaceTextureEntry);
        }
    }

    private void loadImage(final Map<String, Object> maps, final MethodChannel.Result result, String url, final TextureRegistry.SurfaceTextureEntry surfaceTextureEntry) {
        Glide.with(context).asBitmap().load(url).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                if (activity != null) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.error("error", "error", maps);
                        }
                    });
                }
                return false;
            }

            @Override
            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                Log.i("loadImage", "onResourceReady " + surfaceTextureEntry.id());
                try {
                    int bitmapWidth = resource.getWidth();
                    int bitmapHeight = resource.getHeight();
                    Rect rect = new Rect(0, 0, bitmapWidth, bitmapHeight);
                    SurfaceTexture surfaceTexture = surfaceTextureEntry.surfaceTexture();
                    surfaceTexture.setDefaultBufferSize(bitmapWidth, bitmapHeight);
                    Surface surface = new Surface(surfaceTexture);
                    Canvas canvas = surface.lockCanvas(rect);
                    canvas.drawBitmap(resource, null, rect, null);
                    surface.unlockCanvasAndPost(canvas);
                    maps.put("textureId", surfaceTextureEntry.id());
                    maps.put("width", bitmapWidth);
                    maps.put("height", bitmapHeight);
                    if (activity != null) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(maps);
                            }
                        });
                    }
                } catch (Exception e) {
                    if (activity != null) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.error("error", "error", maps);
                            }
                        });
                    }
                }

                return false;
            }
        }).submit();
    }

    private void loadTextureGif(MethodCall call, MethodChannel.Result result) {
//        int textureId = call.argument("textureId");
//        final String url = call.argument("url");
//        Bitmap bitmap = BitmapFactory.decodeResource(this.context.getResources(), R.drawable.jay);
//        int imageWidth = bitmap.getWidth();
//        int imageHeight = bitmap.getHeight();
//        TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = null;
//        for (TextureRegistry.SurfaceTextureEntry entry : textureSurfaces) {
//            if (entry.id() == textureId) {
//                surfaceTextureEntry = entry;
//                break;
//            }
//        }
//        if (surfaceTextureEntry == null) {
//            result.success(-1);
//            return;
//        }
//        Rect rect = new Rect(0, 0, 100, 100);
//        surfaceTextureEntry.surfaceTexture().setDefaultBufferSize(imageWidth, imageHeight);
//        Surface surface = new Surface(surfaceTextureEntry.surfaceTexture());
//        Canvas canvas = surface.lockCanvas(rect);
//        canvas.drawBitmap(bitmap, null, rect, null);
//        bitmap.recycle();
//        surface.unlockCanvasAndPost(canvas);
//        result.success(0);

    }
}
