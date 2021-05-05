<template>
  <vl-layer-group v-if="category" ref="categoryLayer">
    <vl-layer-tile ref="categoryTileLayer" :z-index="10">
      <!-- tile based marker mode -->
      <vl-source-xyz
        v-if="tileImage"
        :url="'/img/markerTile/' + tileImage"
        :projection="define.projection"
        :min-zoom="define.minZoom"
        :max-zoom="define.maxZoom"
        :tile-pixe-ratio="define.tilePixelRatio"
      />
    </vl-layer-tile>
    <!-- location based marker mode -->
    <vl-layer-vector ref="markerLayer" :z-index="15">
      <vl-source-vector :features="features" />
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import { FeatureLike } from 'ol/Feature';
import VectorLayer from 'ol/layer/Vector';
import Map from 'ol/Map';
import { Style } from 'ol/style';
import Source from 'ol/source/Source';
import XYZ from 'ol/source/XYZ';
import { MapDefinition } from '@/types/map';
import { MarkerProperties } from '@/types/markerData';
import define from '@/assets/MapDefinition';
import { getMarkerStyle } from '@/assets/MarkerStyle';
/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
@Component
export default class CategoryLayer extends Vue {
  /** Map definition */
  private define: MapDefinition = define;

  // Markers
  private get features() {
    return this.$store.getters['CategoryMarkerModule/features'](this.category);
  }

  // current category
  private get category(): string | undefined {
    return this.$route.params.category;
  }
  private get types() {
    return this.$store.getters['CategoryMarkerModule/types'](this.category);
  }
  // use marker tile
  private get tileImage() {
    return this.$store.getters['CategoryMarkerModule/tileImage'](this.category);
  }
  // Marker Colorset
  private get colorset() {
    return this.$store.getters['CategoryMarkerModule/colorset'](this.category);
  }
  // Marker Visibility
  private get checked() {
    return this.$store.getters['CheckModule/checked'];
  }

  /**
   * When Page transition
   */
  @Watch('category')
  private async onCategoryChanged() {
    this.$store.dispatch('setLoading', true);
    // タイトルを変更
    const title = process.env.IS_ELECTRON
      ? this.$t('title').replace(/Web/g, 'Electron')
      : this.$t('title');
    this.$store.dispatch('setProgress', null);
    await this.$forceNextTick();

    if (!this.category) {
      document.title = title;
      this.$store.dispatch('setLoading', false);
      await this.$forceNextTick();
      return;
    }

    console.debug('set category:', this.category);
    this.$store.dispatch('CategoryMarkerModule/setCategory', this.category);
    await this.$forceNextTick();
    document.title = this.$t(`categories.${this.category}`) + ' - ' + title;
    // 切り替え完了のメッセージを出力
    this.$store.dispatch(
      'setMessage',
      this.$t('category-changed', {
        category: this.$t(`categories.${this.category}`),
      })
    );
    this.redraw();
    this.$store.dispatch('setLoading', false);
    await this.$forceNextTick();
  }

  @Watch('tileImage')
  private onTileImageChanged() {
    const source: Source = (this.$refs
      .categoryLayerSource as unknown) as Source;

    // 新しい画像レイヤを指定
    if (source) {
      (source as XYZ).setUrl('/img/markerTile/' + this.tileImage);
      // リフレッシュ
      source.refresh();
    }
  }
  1;

  @Watch('checked')
  private onCheckChanged() {
    this.redraw();
  }

  private updated(): void {
    this.redraw();
  }

  /**
   * Redraw markers
   */
  private redraw(): void {
    const markerLayer: VectorLayer = (this.$refs
      .markerLayer as unknown) as VectorLayer;
    if (!markerLayer) return;

    markerLayer.setStyle((feature: FeatureLike, resolution: number) => {
      // vl-map
      const map: Map = (this.$parent as unknown) as Map;
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
      // Get color index from type
      const index = Object.values(this.types).indexOf(type);

      // Apply marker color
      const style: Style = getMarkerStyle(this.colorset[index]);
      // Map zoom
      const scale: number = map.getView().getResolutionForZoom(2) / resolution;

      // Toggle display
      if (!this.checked.includes(type)) {
        // Invisible
        style.getText().setText('');
        style.getImage().setOpacity(0);
      } else {
        // Get Marker Properties
        const props: MarkerProperties = feature.getProperties() as MarkerProperties;

        // Add label to marker
        const label = props.label ? props.label.toString() : '';

        // apply label text
        style.getText().setText(label && scale >= 1 ? label : '');
        style.getImage().setOpacity(1);
      }

      style.getImage().setScale(scale < 1 ? scale : 1);

      return style;
    });
  }
}
</script>
