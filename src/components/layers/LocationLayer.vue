<template>
  <!-- Location Marker markers -->
  <vl-layer-vector ref="locationLayer" :z-index="1" :visible="visibility">
    <vl-source-vector
      ref="vectorSource"
      :features="features"
      :update-while-animating="true"
      :update-while-interacting="true"
    />
  </vl-layer-vector>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import type Map from 'ol/Map';
import type VectorLayer from 'ol/layer/Vector';
import type Style from 'ol/style/Style';
import type Feature from 'ol/Feature';
import type { FeatureLike } from 'ol/Feature';
import { getMarkerIconStyle } from '@/helpers/MarkerStyle';
import type VectorSource from 'ol/source/Vector';

@Component
/**
 * Location Marker (Icon marker)
 */
export default class LocationLayer extends Vue {
  /** Location Markers */
  get features(): Feature[] {
    return this.$store.getters['LocationMarkerModule/features'];
  }
  /** Location Marker Visibility */
  get visibility(): boolean {
    return this.$store.getters['ConfigModule/displayLocation'];
  }
  /** Zoom */
  get zoom(): number {
    return this.$store.getters['MapLocationModule/zoom'];
  }

  @Watch('visibility')
  onVisibilityChanged(value: boolean): void {
    if (value) {
      // 表示するときのみこの処理を動かす
      this.redraw();
    }
  }

  async beforeCreate(): Promise<void> {
    await this.$store.dispatch('setLoading', true);
    await this.$forceNextTick();
    await this.$store.dispatch('LocationMarkerModule/init');
  }

  async mounted(): Promise<void> {
    const vectorSource: VectorSource = this.$refs
      .vectorSource as unknown as VectorSource;

    vectorSource.clear(true);
    vectorSource.addFeatures(this.features);
    await this.$store.dispatch('setLoading', false);
    await this.$forceNextTick();
  }

  /** Redraw Marker Icon */
  @Watch('features')
  private async redraw(): Promise<void> {
    console.log('reload location layer.');
    await this.$nextTick();
    // vl-layer-vector
    const locationLayer = this.$refs
      .locationLayer as unknown as VectorLayer<VectorSource>;

    if (!locationLayer) {
      // コンポーネントが呼び出せる状態になるまでリロード
      this.redraw();
      return;
    }

    // マーカーのスタイルを設定
    locationLayer.setStyle((feature: FeatureLike, resolution: number) => {
      // vl-map
      const map: Map = this.$parent as unknown as Map;
      // マーカーのタイプをアイコンにする
      const type: string = feature.get('type');
      // 注釈（現在のところ、地割れ地点のギリシア文字のみ）
      const label: string = feature.get('label');
      // アイコンのサイズを調整
      const scale: number = map.getView().getResolutionForZoom(2) / resolution;

      // スタイル定義を取得
      const style: Style = getMarkerIconStyle(type);

      // リサイズ
      style.getImage().setScale(scale < 1 ? scale : 1);

      // 注釈を入れる
      style.getText().setText(scale < 1 ? '' : label);

      return style;
    });
  }
}
</script>
