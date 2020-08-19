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
    >
      <vl-geom-point :coordinates="[marker.x, marker.y]" />
      <vl-style-box>
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
      category: null,
      markers: [],
      explains: [],
      config: config,
      set: colorset,
    };
  },
  watch: {
    $route(to, from) {
      this.$root.$data.loading = true;
      this.category = to.params.category;
      this.updateCategoryLayer();
      this.$root.$data.loading = false;
    },
  },
  methods: {
    async updateCategoryLayer() {
      this.opacity = 1;

      if (!this.category) {
        this.explains = null;
        return;
      }
      console.log(this.category);

      // カテゴリが存在する場合、カテゴリの凡例データの含まれたjsonから凡例の項目とカラーセットを取得
      const response = await this.axios
        .get(`/data/${this.category}.json`)
        .catch((err) => {
          console.error(err.message);
          throw new Error(
            `${this.category}.json does not readable or not found.`
          );
        });

      console.debug(response.data);

      // 凡例を書き換え
      this.explains = response.data.explains;

      if (!response.data.markers) {
        const source = this.$refs.categoryLayer.getSource();

        this.markers = [];
        // 画像マーカーモード
        this.opacity = 0.5;
        // const source = this.$refs.categoryLayerSource;

        try {
          // 新しい画像レイヤを指定
          source.setUrl(`/img/markerTile/${this.category}/{z}/{x}/{y}.png`);
          // 表示されている画像データとキャッシュを削除
          source.tileCache.expireCache({});
          source.tileCache.clear();
          // リフレッシュ
          source.refresh();
        } catch (e) {
          // TODO:
        }
      } else {
        // ポイントマーカーモード
        this.opacity = 1;
        // カテゴリマーカー
        this.markers = convertCoordinates(response.data.markers, config.center);
      }
      this.$emit('changed', this.explains, this.set);
      // this.$root.$data.loading = false;
    },
    // 凡例の定義からVuetifyのカラーセットを取得
    // TODO: Vuetifyで定義されていない色や、shadesを指定するとバグる
    getMarkerColor(type) {
      // 凡例の項目順を取得
      const index = Object.keys(this.explains).findIndex(
        (element) => element === type
      );
      // 色名をケバフケースに変換
      const colorName = toKebabCase(this.set.markerColor[index]);
      return colors[colorName];
    },
    hexToRgb(s) {
      return hexToRgb(s);
    },
  },
};
</script>
