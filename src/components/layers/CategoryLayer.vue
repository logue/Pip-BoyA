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
import { MutationPayload } from 'vuex';
/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
@Component
export default class CategoryLayer extends Vue {
  /** Map definition */
  private define: MapDefinition = define;
  // Markers
  private features: FeatureLike[] = [];
  // types
  private types: string[];
  // Color Configure
  private colorset: string[];
  // use marker tile
  private tileImage?: string = null;
  // Marker Visibility
  private checked: string[];

  // Zoom
  private get zoom(): number {
    return this.$store.getters['MapLocationModule/zoom'];
  }
  // current category
  private get category(): string | undefined {
    return this.$route.params.category;
  }

  /**
   * When Page transition
   */
  @Watch('category')
  private async onCategoryChanged() {
    await this.$store.dispatch('setLoading', true);
    // タイトルを変更
    const title = process.env.IS_ELECTRON
      ? this.$t('title').replace(/Web/g, 'Electron')
      : this.$t('title');
    await this.$store.dispatch('setProgress', 10);
    await this.$forceNextTick();

    if (this.category) {
      console.debug('set category:', this.category);
      await this.$store.dispatch(
        'CategoryMarkerModule/setCategory',
        this.category
      );
      document.title = this.$t(`categories.${this.category}`) + ' - ' + title;
      await this.$store.dispatch('setProgress', 20);
      await this.$forceNextTick();

      this.features = this.$store.getters['CategoryMarkerModule/features'](
        this.category
      );
      await this.$store.dispatch('setProgress', 40);
      await this.$forceNextTick();

      // Get types
      this.types = this.$store.getters['CategoryMarkerModule/types'](
        this.category
      );
      await this.$store.dispatch('setProgress', 60);
      await this.$forceNextTick();

      // Get tile image
      this.tileImage = this.$store.getters['CategoryMarkerModule/tileImage'](
        this.category
      );
      await this.$store.dispatch('setProgress', 80);
      await this.$forceNextTick();

      // Marker Colorset
      this.colorset = this.$store.getters['CategoryMarkerModule/colorset'](
        this.category
      );
      await this.$store.dispatch('setProgress', 90);
      await this.$forceNextTick();
      this.redraw();
    } else {
      document.title = title;
      this.features = [];
    }
    await this.$store.dispatch('setProgress', 100);
    await this.$forceNextTick();

    // 切り替え完了のメッセージを出力
    if (this.category) {
      this.$store.dispatch(
        'setMessage',
        this.$t('category-changed', {
          category: this.$t(`categories.${this.category}`),
        })
      );
    }
    this.$store.dispatch('setLoading', false);
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

  @Watch('features')
  private onFeaturesChanged() {
    this.redraw();
  }

  /** When dom ready */
  private mounted() {
    this.$store.subscribe((mutation: MutationPayload) => {
      // Watch explain checked items.
      if (mutation.type === 'CheckModule/set') {
        this.checked = this.$store.getters['CheckModule/checked'];
        this.redraw();
      }
    });
    this.onCategoryChanged();
  }

  public redraw(): void {
    const markerLayer: VectorLayer = (this.$refs
      .markerLayer as unknown) as VectorLayer;
    markerLayer.setStyle((features: FeatureLike, resolution: number) =>
      this.setStyle(features, resolution)
    );
  }

  /**
   * Apply Marker style.
   * @param feature Marker
   * @param resolution Map zoom
   */
  private setStyle(feature: FeatureLike, resolution: number): Style {
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
    // Get Marker Properties
    const props: MarkerProperties = feature.getProperties() as MarkerProperties;

    // Add label to marker
    const label = props.label ? props.label.toString() : '';

    // apply label text
    style.getText().setText(label && scale >= 1 ? label : '');

    // Toggle display
    if (!this.checked.includes(type)) {
      // Invisible
      style.getImage().setOpacity(0);
      style.getText().setText('');
    } else {
      style.getImage().setOpacity(1);
    }

    style.getImage().setScale(scale < 1 ? scale : 1);

    return style;
  }
}
</script>
