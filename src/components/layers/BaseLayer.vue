<template>
  <!-- Base map layers -->
  <vl-layer-group ref="baseLayers" :opacity="opacity">
    <vl-layer-tile :visible="!$root.$data.isMilitary" :z-index="0">
      <vl-source-xyz
        :url="'/img/tiles/base/{z}/{x}/{y}.webp'"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
      />
    </vl-layer-tile>
    <vl-layer-tile :visible="$root.$data.isMilitary" :z-index="1">
      <vl-source-xyz
        :url="'/img/tiles/military/{z}/{x}/{y}.webp'"
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
    };
  },
};
</script>
