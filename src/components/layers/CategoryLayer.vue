<template>
  <vl-layer-group ref="categoryLayer">
    <vl-layer-tile ref="categoryTileLayer" :z-index="10">
      <!-- tile based marker mode -->
      <vl-source-xyz
        ref="tileSource"
        :url="tileImageUrl"
        :projection="mapConfig.projection"
        :min-zoom="mapConfig.minZoom"
        :max-zoom="mapConfig.maxZoom"
        :tile-pixe-ratio="mapConfig.tilePixelRatio"
      />
    </vl-layer-tile>
    <!-- location based marker mode -->
    <vl-layer-vector ref="markerLayer" :z-index="15">
      <vl-source-vector
        ref="vectorSource"
        :features="features"
        :update-while-animating="true"
        :update-while-interacting="true"
      />
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';

import { FeatureLike } from 'ol/Feature';

import Map from 'ol/Map';
import { Style } from 'ol/style';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import { XYZ } from 'ol/source';

import { MapDefinition } from '@/interfaces/MapDefinition';
import { MarkerProperties } from '@/interfaces/MarkerProperties';
import MapConfig from '@/helpers/MapConfig';
import { getMarkerStyle } from '@/helpers/MarkerStyle';
/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
@Component
export default class CategoryLayer extends Vue {
  /** Map definition */
  private mapConfig: MapDefinition = MapConfig;

  /** Markers */
  private features = [];

  /** current category */
  private get category(): string | undefined {
    return this.$route.params.category;
  }
  /** Marker Types */
  private get types() {
    return this.$store.getters['CategoryMarkerModule/types'](this.category);
  }
  /** Marker Colorset */
  private get colorset() {
    return this.$store.getters['CategoryMarkerModule/colorset'](this.category);
  }
  /** Tile Image */
  private get tileImageUrl() {
    return `${process.env.IMG_URI || '/img/'}markerTile/${this.$store.getters[
      'CategoryMarkerModule/tileImage'
    ](this.category)}`;
  }
  /** Marker Visibility */
  private get checked() {
    return this.$store.getters['CheckModule/checked'];
  }

  /**
   * When Page transition
   */
  @Watch('category')
  private async onCategoryChanged() {
    await this.$store.dispatch('setLoading', true);
    await this.$store.dispatch('setProgress', null);
    await this.$forceNextTick();

    // タイトルを変更
    const title = process.env.IS_ELECTRON
      ? this.$t('title').replace(/Web/g, 'Electron')
      : this.$t('title');

    if (!this.category) {
      // カテゴリレイヤーを使わないとき
      document.title = title;
      await this.$store.dispatch('setLoading', false);
      return;
    }

    // this.$refsがundefinedになるのでVue.nextTick();で確実に読み込まれる状態にする。
    await this.$nextTick();
    const source: VectorSource = this.$refs
      .vectorSource as unknown as VectorSource;
    // 既存のマーカーを削除
    source.clear();

    console.debug('CategoryLayer: ', this.category);

    // データ読み込み
    await this.$store
      .dispatch('CategoryMarkerModule/setCategory', this.category)
      .then(args => {
        console.log(
          `CategoryLayer: load ${this.category}, require reload: ${args}`
        );
        if (args) {
          return this.onCategoryChanged();
        }
      });

    await this.$nextTick();

    if (this.$store.getters['CategoryMarkerModule/features'](this.category)) {
      this.features = this.$store.getters['CategoryMarkerModule/features'](
        this.category
      );
      // 算出プロパティでは、VueLayersへfeaturesを流し込む処理が正常に動かないので、手動で代入
      source.addFeatures(this.features);
    } else {
      this.features = [];
    }
    await this.$forceNextTick();

    document.title = this.$t(`categories.${this.category}`) + ' - ' + title;

    // 切り替え完了のメッセージを出力
    await this.$store.dispatch(
      'setMessage',
      this.$t('category-changed', {
        category: this.$t(`categories.${this.category}`),
      })
    );
    await this.$nextTick();

    this.onTileImageChanged();
    this.redraw();
    await this.$forceNextTick();
    await this.$store.dispatch('setLoading', false);
  }

  /** Tile Iamge Mode */
  @Watch('tileImageUrl')
  private async onTileImageChanged() {
    await this.$nextTick();
    const tileSource: XYZ = this.$refs.tileSource as unknown as XYZ;

    if (!tileSource) {
      this.onTileImageChanged();
      return;
    }

    const tile = this.$store.getters['CategoryMarkerModule/tileImage'](
      this.category
    );

    if (tile) {
      // 新しい画像レイヤを指定
      try {
        tileSource.setUrl(
          `${process.env.IMAGE_URI || '/img/'}/markerTile/${tile}`
        );
      } catch (e) {
        // throuh
      }
    }
    // リフレッシュ
    tileSource.refresh();
  }

  @Watch('checked')
  private onCheckChanged() {
    this.redraw();
  }

  /**
   * Redraw markers
   */
  @Watch('features')
  private async redraw() {
    await this.$nextTick();
    const markerLayer: VectorLayer = this.$refs
      .markerLayer as unknown as VectorLayer;

    const source: VectorSource = this.$refs
      .vectorSource as unknown as VectorSource;

    if (!markerLayer) {
      return;
    }

    markerLayer.setStyle((feature: FeatureLike, resolution: number) => {
      // vl-map
      const map: Map = this.$parent as unknown as Map;
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
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
        const props: MarkerProperties =
          feature.getProperties() as MarkerProperties;

        // Add label to marker
        const label = props.label ? props.label.toString() : '';

        // apply label text
        style.getText().setText(label && scale >= 1 ? label : '');
        style.getImage().setOpacity(1);
      }

      style.getImage().setScale(scale < 1 ? scale : 1);

      return style;
    });

    source.refresh();
  }
}
</script>
