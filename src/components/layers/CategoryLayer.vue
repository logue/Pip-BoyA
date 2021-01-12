<template>
  <vl-layer-group ref="categoryLayer">
    <vl-layer-tile
      v-if="$route.params.category"
      ref="categoryTileLayer"
      :z-index="10"
    >
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
import RenderFeature from 'ol/render/Feature';
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
  private features: FeatureLike[] = [];
  // types
  private types = [];
  // Marker Visibility
  public isVisible: Array<boolean> = [];
  // Color Configure
  private colorset: Array<string> = [];
  // use marker tile
  private tileImage?: string = null;

  private key = 0;
  private distance = 40;

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
    console.debug('set category:', this.category);
    if (this.category) {
      await this.$store.dispatch(
        'CategoryMarkerModule/getCategory',
        this.category
      );
    }
    this.init();
  }
  /**
   * When marker changed.
   */
  @Watch('featues')
  private onFeaturesChanged() {
    this.key++;
  }
  /**
   * When switch change visibility
   */
  @Watch('isVisible')
  private onMarkerVisibilityChanged() {
    const layer: VectorLayer = (this.$refs
      .markerLayer as unknown) as VectorLayer;

    // 表示マーカーの設定が変化したとき
    layer.setStyle((features: FeatureLike, resolution: number) => {
      return this.setStyle(features as RenderFeature, resolution);
    });
  }
  /**
   * When change map scale
   */
  @Watch('zoom')
  private onZoomChanged() {
    this.redraw();
  }
  /** When dom ready */
  private mounted() {
    this.init();
  }
  /**
   * Initialize category markers.
   */
  public async init(): Promise<void> {
    if (!this.category) {
      return;
    }
    await this.$store.dispatch('setLoading', true);
    await this.$forceNextTick();
    // タイトルを変更
    const title = process.env.IS_ELECTRON
      ? this.$t('title').replace(/Web/g, 'Electron')
      : this.$t('title');

    if (!this.category) {
      // カテゴリ別のページでない場合、表示中のマーカーを削除して終了
      document.title = title;
      this.features = [];
      this.$store.dispatch('setLoading', false);
    }

    await this.$store.dispatch('setProgress', 20);
    await this.$forceNextTick();
    // マーカーを登録
    this.features = this.$store.getters['CategoryMarkerModule/features'](
      this.category
    );

    await this.$store.dispatch('setProgress', 50);
    await this.$forceNextTick();
    if (this.features) {
      // 種別を登録
      this.types = this.isVisible = this.$store.getters[
        'CategoryMarkerModule/types'
      ](this.category);
    }
    // 画像タイルレイヤ
    this.tileImage = this.$store.getters['CategoryMarkerModule/tileImage'](
      this.category
    );
    // タイトルを書き換える
    document.title = this.$t(`categories.${this.category}`) + ' - ' + title;

    await this.$store.dispatch('setProgress', 70);
    await this.$forceNextTick();
    // 再描画
    this.redraw();

    await this.$store.dispatch('setProgress', 100);
    // ローディングオーバーレイを閉じる
    await this.$store.dispatch('setLoading', false);
    await this.$forceNextTick();

    // 切り替え完了のメッセージを出力
    this.$store.dispatch(
      'setMessage',
      this.$t('category-changed', {
        category: this.$t(`categories.${this.category}`),
      })
    );
  }
  /**
   * Redraw map markers and map tiles.
   */
  public redraw(): void {
    // vl-layer-vector
    const markerLayer: VectorLayer = (this.$refs
      .markerLayer as unknown) as VectorLayer;
    //const tileLayer: TileLayer = (this.$refs
    //  .categoryTileLayer as unknown) as TileLayer;

    if (this.tileImage) {
      const source: Source = (this.$refs
        .categoryLayerSource as unknown) as Source;

      // 新しい画像レイヤを指定
      if (source) {
        (source as XYZ).setUrl('/img/markerTile/' + this.tileImage);
        // リフレッシュ
        source.refresh();
      }
    }
    if (this.features) {
      markerLayer.setStyle((features: FeatureLike, resolution: number) =>
        this.setStyle(features, resolution)
      );
    }
  }
  /**
   * Apply Marker style.
   * @param feature Marker
   * @param resolution Map zoom
   */
  public setStyle(feature: FeatureLike, resolution: number): Style {
    // vl-map
    const map: Map = (this.$parent as unknown) as Map;
    // Get Marker type
    const type = feature.get('type');
    // Get all type list.
    const types = this.$store.getters['CategoryMarkerModule/types'](
      this.category
    );
    // Marker Colorset
    const colorset = this.$store.getters['CategoryMarkerModule/colorset'](
      this.category
    );
    // Get color index from type
    const index = Object.values(types).indexOf(type);

    // Apply marker color
    /*
    const style: Style = this.$store.getters['CategoryMarkerModule/style'](
      colorset[index]
    );
    */
    const style: Style = getMarkerStyle(colorset[index]);
    // Map zoom
    const scale: number = map.getView().getResolutionForZoom(2) / resolution;
    // Get Marker Properties
    const props: MarkerProperties = feature.getProperties() as MarkerProperties;

    // Add label to marker
    const label = props.label ? props.label.toString() : '';

    // apply label text
    style.getText().setText(label && scale >= 1 ? label : '');

    // Toggle display
    if (!this.isVisible.includes(type)) {
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
