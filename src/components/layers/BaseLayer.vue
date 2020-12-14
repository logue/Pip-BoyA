<template>
  <!-- Base map layers -->
  <vl-layer-tile ref="baseLayer" :opacity="opacity" :z-index="-1">
    <vl-source-xyz
      ref="baseLayerSource"
      :url="url"
      :projection="config.projection"
      :min-zoom="config.minZoom"
      :max-zoom="config.maxZoom"
      :tile-pixe-ratio="config.tilePixelRatio"
    />
  </vl-layer-tile>
</template>

<script>
/**
 * Base tile layer.
 */
import config from '@/assets/map.config.js';

const MAPS = ['military', 'base', 'realistic'];

export default {
  data() {
    return {
      // 透過度
      opacity: 1,
      // マップ設定
      config: config,
      // 画像のパス
      url: '/img/tiles/base/{z}/{x}/{y}.webp',
    };
  },
  mounted() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type === 'config/toggleMap') {
        // マップ切り替え
        this.url = `/img/tiles/${MAPS[state.config.map]}/{z}/{x}/{y}.webp`;

        const sourceLayer = this.$refs.baseLayerSource;

        if (sourceLayer) {
          const source = sourceLayer.$source;
          // キャッシュを削除
          source.tileCache.expireCache({});
          source.tileCache.clear();
          // リフレッシュ
          source.refresh();
        }
      }
    });
  },
};
</script>
