<template>
  <!-- Base map layers -->
  <vl-layer-tile ref="baseLayer" :opacity="opacity" :z-index="-1">
    <vl-source-xyz
      ref="baseLayerSource"
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
import { MapDefinition, MapTypes } from '@/types/map';
import config from '@/helpers/MapDefinition';
import XYZ from 'ol/source/XYZ';
import TileLayer from 'ol/layer/Tile';
import TileSource from 'ol/source/Tile';

/**
 * Base tile layer.
 */
@Component
export default class BaseLayer extends Vue {
  /** Map Opacity */
  private opacity = 1;
  /** Map definition */
  private config: MapDefinition = config;

  /** Tile image url pattern */
  private get url() {
    const type: number = this.$store.getters['ConfigModule/mapType'];
    return `${process.env.IMAGE_URI || '/img/'}/tiles/${
      MapTypes[type]
    }/{z}/{x}/{y}.webp`;
  }

  /** When map type changed */
  @Watch('url')
  private onMapChanged() {
    const baseLayer: TileLayer = this.$refs.baseLayer as unknown as TileLayer;
    const source: TileSource = baseLayer.getSource();
    (source as XYZ).setUrl(this.url);
    source.refresh();
  }
}
</script>
