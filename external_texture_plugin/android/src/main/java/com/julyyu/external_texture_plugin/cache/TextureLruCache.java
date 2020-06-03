package com.julyyu.external_texture_plugin.cache;

import android.util.LruCache;

import com.julyyu.external_texture_plugin.SurfaceTextureInfoEntity;

/**
 * @author julyyu
 * @date 2020-06-03.
 * description：
 */
public class TextureLruCache extends LruCache<String, SurfaceTextureInfoEntity> {

    /**
     * @param maxSize for caches that do not override {@link #sizeOf}, this is
     *                the maximum number of entries in the cache. For all other caches,
     *                this is the maximum sum of the sizes of the entries in this cache.
     */
    public TextureLruCache(int maxSize) {
        /// 1024 * 1024 * 200
        super(maxSize);
    }

    public TextureLruCache() {
        /// 1024 * 1024 * 200
        super(1024 * 1024 * 200);
    }

    @Override
    protected int sizeOf(String key, SurfaceTextureInfoEntity value) {
        /// ARGB_8888 占4个字节
        return value.getWidth() * value.getHeight();
    }

}
