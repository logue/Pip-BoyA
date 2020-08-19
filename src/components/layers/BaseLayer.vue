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
    <!-- opacity slider -->
    <v-tooltip bottom>
      <template #activator="{on, attrs}">
        <v-slider
          v-model="opacity"
          step="0.1"
          min="0.1"
          max="1"
          class="map-viewer_opacity-slider"
          v-bind="attrs"
          v-on="on"
        />
      </template>
      <span>{{ $t('opacity') }}</span>
    </v-tooltip>
  </vl-layer-group>
</template>

<script>
import config from '@/assets/map.config.js';

export default {
  data() {
    return {
      opacity: 1,
      config: config,
    };
  },
};
</script>
