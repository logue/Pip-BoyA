<template>
  <vl-layer-group ref="categoryLayer">
    <vl-layer-tile
      v-if="$route.params.category"
      ref="categoryTileLayer"
      :z-index="10"
    >
      <!-- tile based marker mode -->
      <vl-source-xyz
        v-if="tileImage"
        :url="'/img/markerTile/' + tileImage"
        :projection="config.projection"
        :min-zoom="config.minZoom"
        :max-zoom="config.maxZoom"
        :tile-pixe-ratio="config.tilePixelRatio"
      />
    </vl-layer-tile>
    <!-- location based marker mode -->
    <vl-layer-vector ref="markerLayer" :z-index="15">
      <vl-source-vector :features="features" />
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script>
import config from '@/assets/map.config.js';
import {
  convertGeoJson,
  markerStyles,
  valuesOf,
  colorset,
} from '@/assets/utility.js';

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
      colorset: [],
      // Marker Visibiloty
      isVisible: [],
      // use marker tile
      tileImage: false,
    };
  },
  watch: {
    // ページ遷移したとき
    async $route(to) {
      this.$emit('init');
      this.category = to.params.category;
      if (!this.category) {
        document.title = this.$root.$data.title;
        this.features = [];
        return;
      }
      this.features = await this.loadFeatures();
      // タイトルを書き換える
      document.title =
        this.$t(`categories.${this.category}`) + ' - ' + this.$root.$data.title;
      this.redraw();
    },
    isVisible() {
      // 表示マーカーの設定が変化したとき
      this.$refs.markerLayer.setStyle((features) => this.setStyle(features));
    },
  },
  async mounted() {
    this.$emit('init');
    this.category = this.$route.params.category;
    if (!this.category) {
      document.title = this.$root.$data.title;
      if (this.tileImage) {
        // const source = await this.$refs.categoryTileLayer.getSource();
        const source = this.$refs.categoryLayerSource;
        // 新しい画像レイヤを指定
        if (source) {
          source.setUrl('');
          this.clearCache(source);
        }
      }
      return;
    }
    this.features = await this.loadFeatures();
    document.title =
      this.$t(`categories.${this.category}`) + ' - ' + this.$root.$data.title;
    this.redraw();
  },
  methods: {
    // マーカーを追加
    async loadFeatures() {
      this.features = [];
      const locations = await this.axios
        .get(`/data/${this.category}.json`)
        .catch((err) => {
          console.error(err);
        });
      if (!locations.data) {
        return [];
      }

      this.tileImage = locations.data.tileImage || false;

      if (locations.data.markers) {
        // 定義されているマーカーの種類
        const types = locations.data.markers.map((item) => item.type).sort();

        // 表示するマーカーの種類の変数に全種類のマーカーを代入
        const markerTypes = Array.from(new Set(types));

        console.debug(markerTypes);

        if (markerTypes.length > colorset.markerColor.length) {
          throw new Error(
            `Too many marker types. less than ${colorset.markerColor.length}`
          );
        }
        // 表示マーカー
        this.isVisible = markerTypes;
        // マーカー名とその個数の連想配列を生成し、typesに代入
        this.types = types.reduce((prev, cur) => {
          prev[cur] = (prev[cur] || 0) + 1;
          return prev;
        }, {});
        this.colorset = colorset.markerColor;
      } else {
        this.types = locations.data.explains;
        this.colorset = locations.data.colorset || colorset.tileExplainColor;
        return [];
      }
      this.$emit('loaded');
      return convertGeoJson(locations.data.markers, config.center);
    },
    redraw() {
      this.$emit('redraw');
      this.$root.$data.loading = true;
      if (this.tileImage) {
        // const source = await this.$refs.categoryTileLayer.getSource();
        const source = this.$refs.categoryLayerSource;
        // 新しい画像レイヤを指定
        if (source) {
          source.setUrl('/img/markerTile/' + this.tileImage);
          this.clearCache(source);
        }
      }
      // console.log(this.$refs.markerLayer);
      this.$refs.markerLayer.setStyle((features, resolution) =>
        this.setStyle(features, resolution)
      );
      // Force layer to front
      this.$root.$data.loading = false;
      this.$emit('ready', [this.types, this.colorset]);
    },
    // Apply Marker style.
    setStyle(feature, resolution) {
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
      const types = Object.keys(this.types);
      // Get color index from type
      let index = types.indexOf(type);

      if ((this.colorset.length - 3) / types.length > 2) {
        // If there are not enough markers, the colors should be varied.
        // * Ignore Brown and Blue-gray and Gray
        index = (index * ((this.colorset.length - 3) / types.length)) | 0;
      }

      // Apply marker color
      const style = valuesOf(styles)[index];
      // Add label to marker
      const label = feature.values_.label
        ? feature.values_.label.toString()
        : '';
      // Map zoom
      const scale = this.$parent.getView().getResolutionForZoom(2) / resolution;
      // console.log(scale);

      // apply
      if (label && scale >= 1) {
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

      style.getImage().setScale(scale < 1 ? scale : 1);
      return style;
    },
  },
  clearCache(source) {
    if (source.tileCache) {
      // 表示されている画像データとキャッシュを削除
      source.tileCache.expireCache({});
      source.tileCache.clear();
    }
    // リフレッシュ
    source.refresh();
  },
};
</script>
