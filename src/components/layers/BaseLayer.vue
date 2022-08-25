<template>
  <!-- Base map layers -->
  <vl-layer-tile ref="baseLayer" :opacity="opacity" :z-index="-1">
    <vl-source-vector-tile
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
import { MapDefinition } from '@/interfaces/MapDefinition';
import { MapType } from '@/interfaces/MapType';
import config from '@/helpers/MapConfig';
import TileLayer from 'ol/layer/Tile';
import TileSource from 'ol/source/Tile';

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
    console.log(type);
    return `${process.env.IMAGE_URI || '/img/'}tiles/${type}/{z}/{x}/{y}.webp`;
  }

  /** When map type changed */
  @Watch('url')
  onMapChanged() {
    console.log(this.url);
    const baseLayer: TileLayer<TileSource> = this.$refs
      .baseLayer as unknown as TileLayer<TileSource>;
    const source = baseLayer.getSource();
    source?.set('url', this.url);
  }
}
</script>
