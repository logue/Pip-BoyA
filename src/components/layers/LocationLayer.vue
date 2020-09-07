<template>
  <!-- Location Marker markers -->
  <vl-layer-vector ref="locationLayer" :z-index="2" :visible="visible">
    <vl-source-vector
      :features.sync="features"
      :update-while-animating="true"
      :update-while-interacting="true"
    />
  </vl-layer-vector>
</template>

<script>
import colors from 'vuetify/lib/util/colors';
import config from '@/assets/map.config.js';
import {convertGeoJson} from '@/assets/utility.js';
import {Style, Icon, Text, Fill, Stroke} from 'ol/style';

/**
 * Location Marker (Icon marker)
 */
export default {
  data() {
    return {
      // Marker Icon Object cache
      iconCache: {},
      // Markers
      features: [],
      // Marker Styles
      styles: {},
      // Visible Location flag
      visible: Boolean(this.$cookies.get('display-location')),
    };
  },
  watch: {
    '$root.$data.displayLocation'() {
      this.visible = this.$root.$data.displayLocation;
      if (this.visible) {
        this.redraw();
      }
    },
  },
  mounted() {
    this.loadFeatures().then((features) => {
      this.features = features.map(Object.freeze);
      this.redraw();
    });
  },
  methods: {
    // マーカーを追加
    async loadFeatures() {
      const locations = await this.axios
        .get('/data/locations.json')
        .catch((err) => {
          console.error(err);
        });

      // 使用されているマーカーの種類
      const types = Array.from(
        new Set(locations.data.markers.map((item) => item.type))
      ).sort();
      // スタイル定義をキャッシュする
      for (const type of types) {
        this.styles[type] = new Style({
          // アイコン
          image: new Icon({
            src: `/img/marker/${type}.svg`,
            crossOrigin: 'anonymous',
          }),
          // 注釈テキスト
          text: new Text({
            font: 'Noto Sans JP',
            offsetX: 2,
            offsetY: 2,
            // 文字色
            fill: new Fill({
              color: colors.blueGrey.darken4,
            }),
            // 文字のアウトラインの設定
            stroke: new Stroke({
              color: colors.blueGrey.lighten5,
              width: 1,
            }),
          }),
        });
      }
      return convertGeoJson(locations.data.markers, config.center);
    },
    redraw() {
      // マーカーのスタイルを設定
      this.$refs.locationLayer.setStyle((feature, resolution) => {
        // マーカーのタイプをアイコンにする
        const type = feature.get('type');
        // 注釈（現在のところ、地割れ地点のギリシア文字のみ）
        const label = feature.get('label');
        // スタイル定義を取得
        const style = this.styles[type];
        // アイコンのサイズを調整
        const scale =
          this.$parent.getView().getResolutionForZoom(1.5) / resolution;

        // 注釈を入れる
        style.getText().setText(label);
        // リサイズ
        style.getImage().setScale(scale < 1 ? scale : 1);

        return style;
      });
    },
  },
};
</script>
