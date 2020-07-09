package com.julyyu.external_texture_plugin;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.text.TextUtils;
import android.util.Log;
import android.view.Surface;

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
public class SurfaceTextureFactory {


    //    private static HashMap<String, SurfaceTextureInfoEntity> textureLruCache = new HashMap<>();
    private static LinkedList<SurfaceTextureInfoEntity> surfaceTextureEntries = new LinkedList<>();
    private static Map<String, SurfaceTextureInfoEntity> stringSurfaceTextureInfoEntityMap = new HashMap<>();
//    private PluginRegistry.Registrar registrar;
//    private Context mContext;
//    private Activity mActivity;

//    public SurfaceTextureFactory(Context context, Activity activity, PluginRegistry.Registrar registrar) {
//        this.registrar = registrar;
//        this.mContext = context;
//        this.mActivity = activity;
//    }

    static int sum = 0;

    public static void release(
            MethodCall call,
            MethodChannel.Result result) {
        String url = call.argument("url");
        if (TextUtils.isEmpty(url)) {
            Map<String, Object> maps = new HashMap<>();
            result.error("error", "url is null", maps);
            return;
        }
        try {
//            SurfaceTextureInfoEntity surfaceTextureInfoEntity = textureLruCache.remove(url);
//            if (surfaceTextureInfoEntity != null) {
//                //TODO 回收时怎么处理
//                SurfaceTexture surfaceTexture = surfaceTextureInfoEntity.getTextureEntry().surfaceTexture();
//                surfaceTexture.release();
////                surfaceTextureEntries.add(surfaceTextureInfoEntity.getTextureEntry());
//                result.success("");
//            } else {
//                result.success("");
//            }
        } catch (Exception e) {
            result.error("error", "relese fail", "");
        }


    }

    public static void loadImage(Context context,
                                 Activity activity,
                                 MethodCall call,
                                 MethodChannel.Result result,
                                 PluginRegistry.Registrar registrar) {
        String url = call.argument("url");
        if (TextUtils.isEmpty(url)) {
            Map<String, Object> maps = new HashMap<>();
            result.error("error", "url is null", maps);
            return;
        }

//        String id =  call.argument("id").toString();
//        SurfaceTextureInfoEntity surfaceTextureInfoEntity = stringSurfaceTextureInfoEntityMap.get(id);
//        SurfaceTextureInfoEntity surfaceTextureInfoEntity = textureLruCache.get(url);

//        if (surfaceTextureInfoEntity != null) {
//            Map<String, Object> reply = new HashMap<>();
//            reply.put("textureId", surfaceTextureInfoEntity.getTextureEntry().id());
//            reply.put("width", surfaceTextureInfoEntity.getWidth());
//            reply.put("height", surfaceTextureInfoEntity.getHeight());
//            result.success(reply);
//        } else {
        Map<String, Object> reply = new HashMap<>();
        glideLoad(context, activity, reply, result, registrar, url);
//        }
    }


    private static void glideLoad(
            Context context,
            final Activity activity,
            final Map<String, Object> maps,
            final MethodChannel.Result result,
            final PluginRegistry.Registrar registrar,
            final String url) {
        final TextureRegistry.SurfaceTextureEntry surfaceTextureEntry;
        final SurfaceTextureInfoEntity surfaceTextureInfoEntity;
        if (sum >= 30) {
            surfaceTextureInfoEntity = surfaceTextureEntries.removeFirst();
            surfaceTextureEntry = surfaceTextureInfoEntity.getTextureEntry();
//            surfaceTextureEntry.surfaceTexture().releaseTexImage();
//            surfaceTextureEntry.surfaceTexture().release();
//            surfaceTextureInfoEntity.getSurface().release();
//            surfaceTextureEntries.addLast(surfaceTextureInfoEntity);
            Log.i("SurfaceTextureFactory", "glideLoad get Old =------ surfaceTextureEntries: " + surfaceTextureEntries.size() + "\n" +
                    "sum " + sum
            );
        } else {
            surfaceTextureEntry = registrar.textures().createSurfaceTexture();
            Log.i("SurfaceTextureFactory", "glideLoad create");
            surfaceTextureInfoEntity = new SurfaceTextureInfoEntity(0, 0, surfaceTextureEntry, null);
            sum++;
        }
//        if(textureLruCache.size() >= 30){
//            SurfaceTextureInfoEntity surfaceTextureInfoEntity = textureLruCache.entrySet().iterator().next();
//            surfaceTextureEntry = surfaceTextureInfoEntity.getTextureEntry();
//        }else{
//            surfaceTextureEntry = registrar.textures().createSurfaceTexture();
//        }
        Glide.with(context).asBitmap().load(url).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                Log.i("SurfaceTextureFactory", "glideLoad onLoadFailed");
                surfaceTextureEntry.release();
                if (activity != null) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.error("error", "onLoadFailed", maps);
                        }
                    });
                }
                return false;
            }

            @Override
            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                Log.i("SurfaceTextureFactory", "glideLoad onResourceReady");
                try {
                    int bitmapWidth = resource.getWidth();
                    int bitmapHeight = resource.getHeight();
                    Rect rect = new Rect(0, 0, bitmapWidth, bitmapHeight);
                    SurfaceTexture surfaceTexture = surfaceTextureEntry.surfaceTexture();
                    surfaceTexture.setDefaultBufferSize(bitmapWidth, bitmapHeight);
                    Surface surface = surfaceTextureInfoEntity.getSurface();
                    if (surface == null) {
                        surface = new Surface(surfaceTexture);
                    }
                    Canvas canvas = surface.lockCanvas(rect);
                    canvas.drawBitmap(resource, null, rect, null);
                    surface.unlockCanvasAndPost(canvas);
                    maps.put("textureId", surfaceTextureEntry.id());
                    maps.put("width", bitmapWidth);
                    maps.put("height", bitmapHeight);
//                    textureLruCache.put(url, new SurfaceTextureInfoEntity(bitmapWidth, bitmapHeight, surfaceTextureEntry));
                    surfaceTextureInfoEntity.setHeight(bitmapHeight);
                    surfaceTextureInfoEntity.setWidth(bitmapWidth);
                    surfaceTextureInfoEntity.setSurface(surface);
                    surfaceTextureInfoEntity.setTextureEntry(surfaceTextureEntry);
                    surfaceTextureEntries.addLast(surfaceTextureInfoEntity);
                    if (activity != null) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(maps);
                            }
                        });
                    }
                } catch (final Exception e) {
                    if (activity != null) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.error("error", e.getMessage(), maps);
                            }
                        });
                    }
                }

                return false;
            }
        }).submit();
    }


}
