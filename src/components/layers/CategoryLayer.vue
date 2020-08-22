<template>
  <vl-layer-tile v-if="category" ref="categoryLayer" :opacity="1" :z-index="2">
    <!-- tile based marker mode -->
    <vl-source-xyz
      v-if="markers.length === 0"
      ref="categoryLayerSource"
      :url="`/img/markerTile/${category}/{z}/{x}/{y}.png`"
      :projection="config.projection"
      :min-zoom="config.minZoom"
      :max-zoom="config.maxZoom"
      :tile-pixe-ratio="config.tilePixelRatio"
    />
    <!-- location based marker mode -->
    <vl-feature
      v-for="marker in markers"
      v-else
      :key="marker.id"
      :properties="marker"
      :label="marker.annotation || ''"
    >
      <vl-geom-point :coordinates="[marker.x, marker.y]" />
      <vl-style-box>
        <!-- vl-style-text v-if="marker.annotation" :text="marker.annotation">
          <vl-style-stroke :width="3" color="rgba(250,0,0,0.8)" />
          <vl-style-fill :color="getMarkerColor(marker.type).base" />
        </vl-style-text -->
        <vl-style-circle>
          <vl-style-stroke :color="getMarkerColor(marker.type).base" />
          <vl-style-fill
            :color="`rgba(${hexToRgb(
              getMarkerColor(marker.type).lighten4
            )},0.5)`"
          />
        </vl-style-circle>
      </vl-style-box>
    </vl-feature>
  </vl-layer-tile>
</template>

<script>
import colors from 'vuetify/lib/util/colors';

import config from '@/assets/map.config.js';
import colorset from '@/assets/colorset.json';
import {convertCoordinates, hexToRgb, toKebabCase} from '@/assets/utility.js';

/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
export default {
  emits: ['changed'],
  data() {
    return {
      // Current Category
      category: null,
      // Loaded markers
      markers: [],
      // Explain definition
      explains: {},
      // Map Configure
      config: config,
      // Color Configure
      set: colorset,
    };
  },
  methods: {
    /**
     * Redraw category layer.
     *
     * @param {Object} data category.json
     */
    updateCategoryLayer(data) {
      this.$root.$data.loading = true;
      console.debug(this.category, data);
      this.data = data;
      const tileMarkerMode = !data.markers;
      if (tileMarkerMode) {
        // 画像マーカーモード

        // マーカーをクリア
        this.markers = [];

        // const source = this.$refs.categoryLayer.getSource();
        const source = this.$refs.categoryLayerSource;

        if (source) {
          // 新しい画像レイヤを指定
          try {
            source.setUrl(`/img/markerTile/${this.category}/{z}/{x}/{y}.png`);
          } catch (e) {
            // ???
          }

          if (source.tileCache) {
            // 表示されている画像データとキャッシュを削除
            source.tileCache.expireCache({});
            source.tileCache.clear();
          }
          // リフレッシュ
          source.refresh();
        }
      } else {
        // カテゴリマーカー
        this.markers = data.reductionRate
          ? convertCoordinates(data.markers, config.center, data.reductionRate)
          : convertCoordinates(data.markers, config.center);
      }
      this.$emit('changed', tileMarkerMode);
      this.$root.$data.loading = false;
    },
    /**
     * Get marker color from explains definiton.
     *
     * @param {String} type Marker type
     * @return {Object} Vuetify color array
     */
    getMarkerColor(type) {
      // 凡例の項目順を取得
      let index = 0;
      if (this.data.explains) {
        if (this.data.explains.length > this.set.markerColor.length) {
          throw new Error(
            `Too many Explains. less than ${this.set.markerColor.length}`
          );
        }
        index = Object.keys(this.data.explains).findIndex(
          (element) => element === type
        );
      }
      // console.log(type, index, this.set.markerColor[index]);

      // 色名をケバフケースに変換
      const colorName = toKebabCase(this.set.markerColor[index]);
      return colors[colorName];
    },
    /**
     * Hex color to rgb color array
     * @param {String} s hex
     * @return {Array}
     */
    hexToRgb(s) {
      return hexToRgb(s);
    },
  },
};
</script>
