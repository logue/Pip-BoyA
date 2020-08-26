<template>
  <!-- Location Marker markers -->
  <vl-layer-vector ref="locationLayer" :z-index="3" :visible="visible">
    <vl-source-vector :features.sync="features" />
  </vl-layer-vector>
</template>

<script>
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
      visible: this.$root.$data.displayLocation,
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
    this.$root.$data.loading = true;

    this.loadFeatures().then((features) => {
      this.features = features.map(Object.freeze);
      this.redraw();
      this.$root.$data.loading = false;
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
      return convertGeoJson(locations.data.markers, config.center);
    },
    redraw() {
      // アイコンを指定
      this.$refs.locationLayer.setStyle((feature, resolution) => {
        const style = {};
        // マーカーのタイプをアイコンにする
        const type = feature.get('type');
        // ちらつきを防ぐため、Iconオブジェクトはキャッシュする。
        if (this.iconCache[type]) {
          style.image = this.iconCache[type];
        } else {
          style.image = this.iconCache[type] = new Icon({
            src: `/img/marker/${type}.svg`,
            crossOrigin: 'anonymous',
          });
        }

        if (feature.get('label')) {
          // 注釈を入れる（現在のところ、地割れ地点のギリシア文字のみ）
          style.text = new Text({
            text: feature.get('label'),
            font: 'Noto Sans JP',
            offsetX: 2,
            offsetY: 2,
            fill: new Fill({
              color: '#263238',
            }),
            stroke: new Stroke({
              color: '#ECEFF1',
              width: 1,
            }),
          });
        }

        return new Style(style);
      });
    },
    setScale() {
      // TODO
    },
  },
};
</script>
