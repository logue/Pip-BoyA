<template>
  <!-- Base map layers -->
  <vl-layer-tile ref="baseLayer" :opacity="opacity" :z-index="-1">
    <vl-source-xyz
      :url="url"
      :projection="config.projection"
      :min-zoom="config.minZoom"
      :max-zoom="config.maxZoom"
      :max-resolution="config.mapMaxResolution"
      :tile-pixe-ratio="config.tilePixelRatio"
    />
  </vl-layer-tile>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import type { MapDefinition } from '@/interfaces/MapDefinition';
import type { MapType } from '@/interfaces/MapType';
import config from '@/helpers/MapConfig';
import type TileLayer from 'ol/layer/Tile';
import type { XYZ } from 'ol/source';

@Component
/**
 * Base tile layer.
 */
export default class BaseLayer extends Vue {
  /** Map Opacity */
  opacity = 1;
  /** Map definition */
  config: MapDefinition = config;

  /** Tile image url pattern */
  get url() {
    const type: MapType = this.$store.getters['ConfigModule/mapType'];
    return `${process.env.IMAGE_URI || '/img/'}tiles/${type}/{z}/{x}/{y}.webp`;
  }

  /** When map type changed */
  @Watch('url')
  onMapChanged() {
    const baseLayer: TileLayer<XYZ> = this.$refs
      .baseLayer as unknown as TileLayer<XYZ>;
    const source = baseLayer.getSource();
    if (source) {
      source.set('url', this.url);
      source.refresh();
    }
  }
}
</script>
