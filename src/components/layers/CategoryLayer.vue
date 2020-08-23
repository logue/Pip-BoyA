<template>
  <vl-layer-group v-if="category" :opacity="1" :z-index="2">
    <vl-layer-tile v-if="markers.length === 0">
      <!-- tile based marker mode -->
      <vl-source-xyz
        ref="categoryLayerSource"
        :url="`/img/markerTile/${category}/{z}/{x}/{y}.png`"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
      />
    </vl-layer-tile>
    <vl-layer-vector
      v-for="(items, index) in markers"
      :key="index"
      :ref="index"
      :visible="true"
    >
      <!-- location based marker mode -->
      <vl-feature
        v-for="marker in items"
        :key="marker.id"
        :properties="marker"
        :label="marker.annotation || ''"
      >
        <vl-geom-point :coordinates="[marker.x, marker.y]" />
        <vl-style-box>
          <vl-style-text
            v-if="marker.annotation && marker.annotation.toString().length <= 2"
            font="'Noto Sans JP'"
            :text="marker.annotation.toString()"
          >
            <vl-style-stroke
              :width="2"
              :color="`rgba(${hexToRgb(
                getMarkerColor(marker.type).lighten5
              )},0.5)`"
            />
            <vl-style-fill :color="getMarkerColor(marker.type).darken4" />
          </vl-style-text>
          <vl-style-circle>
            <vl-style-stroke
              :color="
                getMarkerColor(marker.type).accent3 ||
                getMarkerColor(marker.type).darken3
              "
            />
            <vl-style-fill
              :color="`rgba(${hexToRgb(
                getMarkerColor(marker.type).accent1 ||
                  getMarkerColor(marker.type).lighten5
              )},0.3)`"
            />
          </vl-style-circle>
        </vl-style-box>
      </vl-feature>
    </vl-layer-vector>
  </vl-layer-group>
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
      markers: {},
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
        this.markers = {};

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
        const markers = data.reductionRate
          ? convertCoordinates(data.markers, config.center, data.reductionRate)
          : convertCoordinates(data.markers, config.center);

        // 定義されているマーカーの種類
        const types = Array.from(new Set(markers.map((item) => item.type)));
        if (types.length > this.set.markerColor.length) {
          throw new Error(
            `Too many marker types. less than ${this.set.markerColor.length}`
          );
        }

        for (const type of types) {
          this.markers[type] = markers.filter((item) => item.type === type);
        }
        // console.log(this.markers);
      }
      this.$emit('changed', tileMarkerMode);
      this.$root.$data.loading = false;
    },
    // 凡例で選択された配列のレイヤーのみ表示する
    setMarkerVisibility(markers) {
      for (const layer in this.$refs) {
        if (
          {}.hasOwnProperty.call(this.$refs, layer) &&
          layer.match(/Marker$/)
        ) {
          // TODO: エラーになる
          // this.$refs[layer][0].visible = markers.includes(layer);
        }
      }
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
      // console.log(c);
      let colorName = null;
      try {
        colorName = toKebabCase(this.set.markerColor[index]);
      } catch (e) {
        console.error(
          'type:',
          type,
          'colorset:',
          this.set,
          ' index:',
          index,
          'result:',
          this.set.markerColor[index]
        );
        throw new Error('could not get marker color.');
      }

      return colors[colorName];
    },
    /**
     * Hex color to rgb color array
     * @param {String} s hex
     * @return {Array}
     */
    hexToRgb(s) {
      try {
        return hexToRgb(s);
      } catch (e) {
        console.error(s, e);
      }
    },
  },
};
</script>
