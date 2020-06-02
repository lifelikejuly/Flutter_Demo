package com.julyyu.external_texture_plugin;

import io.flutter.view.TextureRegistry;

/**
 * @author julyyu
 * @date 2020-06-02.
 * description：
 */
public class TextureEntity {

    private int width;
    private int height;
    private TextureRegistry.SurfaceTextureEntry textureEntry;



    public TextureEntity(int width, int height, TextureRegistry.SurfaceTextureEntry textureEntry) {
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
}
