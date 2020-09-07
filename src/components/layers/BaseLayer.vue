<template>
  <!-- Base map layers -->
  <vl-layer-group ref="baseLayers" :opacity="opacity" :z-index="0">
    <vl-layer-tile :visible="$root.$data.isMilitary === true">
      <vl-source-xyz
        :url="'/img/tiles/military/{z}/{x}/{y}.webp'"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
        @tileloadstart="onTileLoadStart"
        @tileloadend="onTileLoadEnd"
        @tileloaderror="onTileLoadError"
      />
    </vl-layer-tile>
    <vl-layer-tile :visible="!$root.$data.isMilitary">
      <vl-source-xyz
        :url="'/img/tiles/base/{z}/{x}/{y}.webp'"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
        @tileloadstart="onTileLoadStart"
        @tileloadend="onTileLoadEnd"
        @tileloaderror="onTileLoadError"
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
    };
  },
  methods: {
    // ロード開始
    onTileLoadStart() {
      // this.$root.$data.loading = true;
    },
    // ロード終了
    onTileLoadEnd() {
      // this.$root.$data.loading = false;
    },
    // エラー
    onTileLoadError() {
      // this.$root.$data.loading = false;
      // TODO
    },
  },
};
</script>
