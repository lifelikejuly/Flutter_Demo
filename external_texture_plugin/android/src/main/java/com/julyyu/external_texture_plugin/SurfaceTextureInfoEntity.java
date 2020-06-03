package com.julyyu.external_texture_plugin;

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
    private TextureRegistry.SurfaceTextureEntry textureEntry;




    public SurfaceTextureInfoEntity(int width, int height, TextureRegistry.SurfaceTextureEntry textureEntry) {
        this.width = width;
        this.height = height;
        this.textureEntry = textureEntry;
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
}
