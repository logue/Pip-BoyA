<template>
  <!-- Location Marker markers -->
  <vl-layer-vector ref="locationLayer" :z-index="1" :visible="visible">
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
      // center location
      coordinates: [0, 0],
    };
  },
  computed: {
    visible() {
      return this.$store.state.config.displayLocation;
    },
  },
  async created() {
    // クエリから座標を取得
    this.coordinates = [this.$route.query.x | 0, this.$route.query.y | 0];

    const locations = await this.axios
      .get('/data/locations.json')
      .catch((err) => console.error(err));

    const markers = locations.data.markers;

    // 使用されているマーカーの種類
    const types = Array.from(new Set(markers.map((item) => item.type))).sort();

    // 外部からリンクしたときのマーカー
    types.push('WaypointMarker');

    // スタイル定義をキャッシュする
    for (const type of types) {
      this.styles[type] = new Style({
        // アイコン
        image: new Icon({
          src: `/img/marker/${type}.svg`,
          scale: [1, 1],
          crossOrigin: 'anonymous',
          anchor: [0.5, type === 'WaypointMarker' ? 0.9 : 0.5],
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

    // マーカーの座標
    const features = convertGeoJson(markers, config.center);
    if (this.coordinates !== [0, 0]) {
      // 外部からのリンクのときに、その場所にマーカーアイコンを設置
      features.push({
        geometry: {
          type: 'Point',
          coordinates: this.coordinates,
        },
        properties: {
          type: 'WaypointMarker',
          x: this.coordinates[0],
          y: this.coordinates[1],
        },
        type: 'Feature',
      });
    }
    // console.log(features);
    this.features = features.map(Object.freeze);
    this.redraw();
  },
  mounted() {
    this.redraw();
  },
  methods: {
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
          this.$parent.getView().getResolutionForZoom(2) / resolution;

        // 注釈を入れる
        style.getText().setText(scale < 1 ? '' : label);

        // リサイズ
        style.getImage().setScale(scale < 1 ? scale : 1);

        return style;
      });
    },
  },
};
</script>
