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
      <vl-source-vector :features="features" />
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
      isVisible: [],
    };
  },
  watch: {
    async $route(to) {
      this.$emit('init');
      this.features = await this.loadFeatures(to.params.category);
      this.category = to.params.category;
      this.redraw();
    },
    isVisible() {
      this.$refs.markerLayer.setStyle((features) => this.setStyle(features));
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
        const types = locations.data.markers.map((item) => item.type).sort();

        // 表示するマーカーの種類の変数に全種類のマーカーを代入
        const markerTypes = Array.from(new Set(types));

        console.debug(markerTypes);

        if (markerTypes.length > this.set.markerColor.length) {
          throw new Error(
            `Too many marker types. less than ${this.set.markerColor.length}`
          );
        }
        this.isVisible = markerTypes;
        this.types = types.reduce((prev, cur) => {
          prev[cur] = (prev[cur] || 0) + 1;
          return prev;
        }, {});
      } else {
        this.types = locations.data.explains;
        return [];
      }
      this.$emit('loaded');
      return convertGeoJson(locations.data.markers, config.center);
    },
    redraw() {
      this.$emit('redraw');
      this.$root.$data.loading = true;
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
        this.$refs.markerLayer.setStyle((features) => this.setStyle(features));
      }
      this.$root.$data.loading = false;
      this.$emit('ready', this.types);
    },
    // Apply Marker style.
    setStyle(feature) {
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
      const types = Object.keys(this.types);
      // Get color index from type
      let index = types.indexOf(type);

      if (this.set.markerColor.length / types.length > 2) {
        // If there are not enough markers, the colors should be varied.
        index = (index * (this.set.markerColor.length / types.length)) | 0;
      }

      // Apply marker color
      const style = valuesOf(styles)[index];
      // Add label to marker
      const label = feature.values_.label
        ? feature.values_.label.toString()
        : '';
      // apply
      if (label && label.length <= 2) {
        style.getText().setText(label);
      } else {
        style.getText().setText('');
      }

      // Toggle display
      if (!this.isVisible.includes(type)) {
        // Invisible
        style.getImage().setOpacity(0);
        style.getText().setText('');
      } else {
        style.getImage().setOpacity(1);
      }
      return style;
    },
  },
};
</script>
