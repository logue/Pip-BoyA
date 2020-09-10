<template>
  <!-- Base map layers -->
  <vl-layer-group ref="baseLayer" :opacity="opacity" :z-index="0">
    <vl-layer-tile>
      <vl-source-xyz
        ref="baseLayerSource"
        :url="url"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
      />
    </vl-layer-tile>
  </vl-layer-group>
</template>

<script>
/**
 * Base tile layer.
 */
import config from '@/assets/map.config.js';

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
  watch: {
    '$root.$data.isMilitary'() {
      this.redraw();
    },
  },
  created() {
    this.redraw();
  },
  methods: {
    async redraw() {
      // 軍用マップ切り替え
      this.url = `/img/tiles/${
        this.$root.$data.isMilitary ? 'military' : 'base'
      }/{z}/{x}/{y}.webp`;
      // マップのリロード
      const sourceLayer = await this.$refs.baseLayerSource;

      if (sourceLayer) {
        const source = sourceLayer.$source;
        // キャッシュを削除
        source.tileCache.expireCache({});
        source.tileCache.clear();
        // リフレッシュ
        source.refresh();
      }
    },
  },
};
</script>
