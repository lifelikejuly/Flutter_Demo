package com.julyyu.external_texture_plugin;

import android.view.Surface;

import io.flutter.view.TextureRegistry;

/**
 * @author julyyu
 * @date 2020-06-02.
 * description：
 */
public class SurfaceTextureInfoEntity {

    private int width;
    private int height;
    private boolean release = false;
    private Surface surface;
    private TextureRegistry.SurfaceTextureEntry textureEntry;




    public SurfaceTextureInfoEntity(int width, int height, TextureRegistry.SurfaceTextureEntry textureEntry,Surface surface) {
        this.width = width;
        this.height = height;
        this.textureEntry = textureEntry;
        this.surface = surface;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public TextureRegistry.SurfaceTextureEntry getTextureEntry() {
        return textureEntry;
    }

    public void setTextureEntry(TextureRegistry.SurfaceTextureEntry textureEntry) {
        this.textureEntry = textureEntry;
    }

    public boolean isRelease() {
        return release;
    }

    public void setRelease(boolean release) {
        this.release = release;
    }

    public Surface getSurface() {
        return surface;
    }

    public void setSurface(Surface surface) {
        this.surface = surface;
    }
}
