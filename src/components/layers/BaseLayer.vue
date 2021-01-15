<template>
  <!-- Base map layers -->
  <vl-layer-tile ref="baseLayer" :opacity="opacity" :z-index="-1">
    <vl-source-xyz
      ref="baseLayerSource"
      :url="url"
      :projection="define.projection"
      :min-zoom="define.minZoom"
      :max-zoom="define.maxZoom"
      :max-resolution="define.mapMaxResolution"
      :tile-pixe-ratio="define.tilePixelRatio"
    />
  </vl-layer-tile>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import Tile from 'ol/layer/Tile';
import { MapDefinition, MapTypes } from '@/types/map';
import define from '@/assets/MapDefinition';
import Source from 'ol/source/Source';
import XYZ from 'ol/source/XYZ';

/**
 * Base tile layer.
 */
@Component
export default class BaseLayer extends Vue {
  /** Map Opacity */
  private opacity = 1;
  /** Map definition */
  private define: MapDefinition = define;

  /** Tile image url pattern */
  private get url() {
    const type: number = this.$store.getters['ConfigModule/mapType'];
    return `/img/tiles/${MapTypes[type]}/{z}/{x}/{y}.webp`;
  }

  /** When map type changed */
  @Watch('url')
  private onMapChanged() {
    // console.log('onMapChanged');
    const baseLayer: Tile = (this.$refs.baseLayer as unknown) as Tile;
    const source: Source = baseLayer.getSource();
    (source as XYZ).setUrl(this.url);
    source.refresh();
    /*
    if (source) {
      // キャッシュを削除
      source.tileCache.expireCache({});
      source.tileCache.clear();
    }
    */
  }
}
</script>
