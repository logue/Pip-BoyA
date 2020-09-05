<template>
  <vl-layer-group :opacity="1" :z-index="3" class="category-layer">
    <vl-layer-tile ref="categoryTileLayer">
      <!-- tile based marker mode -->
      <vl-source-xyz
        :url="'/img/markerTile/' + $route.params.category + '/{z}/{x}/{y}.png'"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
      />
    </vl-layer-tile>
    <!-- location based marker mode -->
    <vl-layer-vector ref="markerLayer">
      <vl-source-vector :features.sync="features" />
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script>
import config from '@/assets/map.config.js';
import colorset from '@/assets/colorset.json';
import {convertGeoJson, markerStyles, valuesOf} from '@/assets/utility.js';

const styles = markerStyles();

/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
export default {
  emits: ['init', 'loaded', 'redraw', 'ready'],
  data() {
    return {
      // Markers
      features: [],
      // types
      types: [],
      // Map Configure
      config: config,
      // Color Configure
      set: colorset,
      // Marker Visibiloty
      visible: {},
    };
  },
  watch: {
    async $route(to) {
      this.$emit('init');
      this.features = await this.loadFeatures(to.params.category);
      this.category = to.params.category;
      this.redraw();
    },
  },
  async mounted() {
    this.$emit('init');
    this.features = await this.loadFeatures(this.$route.params.category);
    this.category = this.$route.params.category;
  },
  updated() {
    this.redraw();
  },
  methods: {
    // マーカーを追加
    async loadFeatures(category) {
      this.features = [];
      const locations = await this.axios
        .get(`/data/${category}.json`)
        .catch((err) => {
          console.error(err);
        });
      if (!locations.data) {
        return;
      }

      if (locations.data.markers) {
        // 定義されているマーカーの種類
        const types = Array.from(
          new Set(locations.data.markers.map((item) => item.type))
        ).sort();

        if (types.length > this.set.markerColor.length) {
          throw new Error(
            `Too many marker types. less than ${this.set.markerColor.length}`
          );
        }
        this.types = types;
      } else {
        this.types = locations.data.explains;

        return [];
      }
      this.$emit('loaded');
      return convertGeoJson(locations.data.markers, config.center);
    },
    async redraw() {
      this.$emit('redraw');
      if (this.features.length === 0) {
        // const source = await this.$refs.categoryTileLayer.getSource();
        const source = this.$refs.categoryLayerSource;

        if (source) {
          // 新しい画像レイヤを指定
          source.setUrl(
            '/img/markerTile/' + this.category + '/{z}/{x}/{y}.png'
          );
          if (source.tileCache) {
            // 表示されている画像データとキャッシュを削除
            source.tileCache.expireCache({});
            source.tileCache.clear();
          }
          // リフレッシュ
          source.refresh();
        }
      } else {
        // console.log(this.$refs.markerLayer);
        await this.$refs.markerLayer.setStyle((features) =>
          this.setStyle(features)
        );
      }
      this.$emit('ready', this.types);
    },
    setStyle(feature) {
      // マーカーのタイプを色のインデックスにする
      let index = this.types.indexOf(feature.get('type'));

      if (this.set.markerColor.length / this.types.length > 2) {
        // マーカーの種類が少ない場合、色がバラけるようにする。
        index = (index * (this.set.markerColor.length / this.types.length)) | 0;
      }

      const style = valuesOf(styles)[index];
      const label = feature.values_.label
        ? feature.values_.label.toString()
        : '';
      if (label && label.length <= 2) {
        style.getText().setText(label);
      } else {
        style.getText().setText('');
      }
      return style;
    },
    // 凡例で選択された配列のレイヤーのみ表示する
    setMarkerVisibility(markers) {
      for (const marker of markers) {
        for (const feature of this.features) {
          if (feature.properties.type === marker) {
            continue;
          }
          feature.style = {visibility: 'hidden'};
        }
      }
      this.redraw();
    },
  },
};
</script>
