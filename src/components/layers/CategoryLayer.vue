<template>
  <vl-layer-group
    v-if="category"
    :opacity="1"
    :z-index="2"
    class="category-layer"
  >
    <vl-layer-tile v-if="tileMarkerMode">
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
      v-else
      :key="index"
      :ref="index"
      :title="index"
      :visible="true"
    >
      <!-- location based marker mode -->
      <vl-feature v-for="marker in items" :key="marker.id" :properties="marker">
        <vl-geom-point :coordinates="[marker.x, marker.y]" />
        <vl-style-box>
          <vl-style-text
            v-if="marker.label && marker.label.toString().length <= 2"
            font="'Noto Sans JP'"
            :text="marker.label.toString()"
          >
            <vl-style-stroke
              :width="2"
              :color="`rgba(${hexToRgb(
                markerColor[marker.type].lighten5
              )},0.5)`"
            />
            <vl-style-fill :color="markerColor[marker.type].darken4" />
          </vl-style-text>
          <vl-style-circle>
            <vl-style-stroke
              :color="
                markerColor[marker.type].accent3 ||
                markerColor[marker.type].darken3
              "
            />
            <vl-style-fill
              :color="`rgba(${hexToRgb(
                markerColor[marker.type].accent1 ||
                  markerColor[marker.type].lighten5
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
      // Marker color
      markerColor: {},
      // Explain definition
      explains: {},
      // Map Configure
      config: config,
      // Color Configure
      set: colorset,

      tileMarkerMode: true,
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
      this.tileMarkerMode = !data.markers;

      // マーカーをクリア
      this.markers = {};
      this.markerColor = {};

      if (this.tileMarkerMode) {
        // 画像マーカーモード

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

        // 定義されているマーカーの種類
        const types = Array.from(
          new Set(data.markers.map((item) => item.type))
        ).sort();
        if (types.length > this.set.markerColor.length) {
          throw new Error(
            `Too many marker types. less than ${this.set.markerColor.length}`
          );
        }

        // カテゴリ別にマーカーを整理
        for (let i = 0; i < types.length; i++) {
          const type = types[i];
          // 座標系をピクセル指定に変換する
          this.markers[type] = convertCoordinates(
            data.markers.filter((item) => item.type === type),
            config.center,
            data.reductionRate || undefined
          );
          // マーカーの色定義
          this.markerColor[type] = colors[toKebabCase(this.set.markerColor[i])];
        }
        console.debug(this.markers, this.markerColor);
      }
      this.$emit('changed', this.tileMarkerMode);
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
