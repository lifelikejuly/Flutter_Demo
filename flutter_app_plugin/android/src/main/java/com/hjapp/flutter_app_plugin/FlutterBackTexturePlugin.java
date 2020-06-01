package com.hjapp.flutter_app_plugin;


import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;

/**
 * @author julyyu
 * @date 2020-05-29.
 * description：
 */
public class FlutterBackTexturePlugin implements FlutterPlugin {

    static HashMap<String, TextureRegistry.SurfaceTextureEntry> textureSurfaces = new HashMap<>();

    private FlutterBackTexturePlugin(PluginRegistry.Registrar registrar) {
        TextureRegistry textureRegistry = registrar.textures();
        TextureRegistry.SurfaceTextureEntry surfaceTextureEntry = textureRegistry.createSurfaceTexture();
        long textureId = surfaceTextureEntry.id();
        Map<String, Object> reply = new HashMap<>();
        reply.put("textureId", textureId);
        textureSurfaces.put(String.valueOf(textureId), surfaceTextureEntry);
//        result.success(reply);
    }



    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

    }
}
