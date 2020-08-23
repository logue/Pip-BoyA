<template>
  <!-- Map markers -->
  <vl-layer-vector :z-index="3">
    <vl-feature v-for="marker in markers" :key="marker.id" :properties="marker">
      <vl-geom-point :coordinates="[marker.x, marker.y]" />
      <vl-style-box>
        <vl-style-icon
          :src="`/img/marker/${marker.type}.svg`"
          :img-size="[32, 32]"
          :scale="scale"
          cross-origin="anonymous"
        />
        <vl-style-text
          v-if="marker.annotation"
          font="'Noto Sans JP'"
          :offset-x="2"
          :offset-y="2"
          :text="marker.annotation.toString()"
        >
          <vl-style-stroke :width="2" color="#ECEFF1" />
          <vl-style-fill color="#263238" />
        </vl-style-text>
      </vl-style-box>
    </vl-feature>
    <vl-interaction-select hover @select="onSelect" />
  </vl-layer-vector>
</template>

<script>
import config from '@/assets/map.config.js';
import {convertCoordinates} from '@/assets/utility.js';

/**
 * Location Marker (Icon marker)
 */
export default {
  emits: ['marker-select'],
  data() {
    return {
      markers: {},
      zoom: 1,
      scale: 1,
      visible: false,
    };
  },
  async mounted() {
    this.$root.$data.loading = true;
    const locations = await this.axios
      .get('/data/locations.json')
      .catch((err) => {
        console.error(err);
      });

    this.markers = convertCoordinates(locations.data.markers, config.center);
    this.$root.$data.loading = false;
  },
  methods: {
    // マーカーをクリックしたときの処理
    onSelect(feature) {
      const value = feature.values_;
      if (!value) {
        return;
      }
      this.$emit('marker-select', value);
    },
    // アイコンの大きさ調整
    setScale(zoom) {
      switch (zoom | 0) {
        case 0:
          this.scale = 0.5;
          break;
        case 1:
          this.scale = 0.75;
          break;
        case 2:
          this.scale = 1;
          break;
        case 3:
          this.scale = 1.25;
          break;
        case 4:
          this.scale = 1.5;
          break;
        default:
          this.scale = 1;
          break;
      }
    },
    toggleVisible(visibility) {
      this.visible = visibility;
    },
  },
};
</script>
