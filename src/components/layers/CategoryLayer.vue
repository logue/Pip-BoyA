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
import {markerStyles} from '@/assets/utility.js';

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
      // Marker Visibiloty
      isVisible: [],
      // Map Configure
      config: config,
      // Color Configure
      colorset: [],
      // use marker tile
      tileImage: false,
    };
  },
  watch: {
    // ページ遷移したとき
    $route(to) {
      this.category = to.params.category;
      this.init();
    },
    isVisible() {
      // 表示マーカーの設定が変化したとき
      this.$refs.markerLayer.setStyle((features, resolution) =>
        this.setStyle(features, resolution)
      );
    },
  },
  mounted() {
    this.category = this.$route.params.category;
    this.init();
  },
  methods: {
    init() {
      this.$store.dispatch('setLoading', true);
      this.$emit('init');

      const title = process.env.IS_ELECTRON
        ? this.$t('title').replace(/Web/g, 'Electron')
        : this.$t('title');

      if (!this.category) {
        document.title = title;
        this.features = [];
        this.$store.dispatch('setLoading', false);
        return;
      }
      this.$store.dispatch('setProgress', 10);
      console.debug('set category:', this.category);
      if (!this.$store.getters['marker/types'](this.category)) {
        this.$store.dispatch('marker/getCategory', this.category);
      }
      this.$store.dispatch('setProgress', 30);
      // マーカーを登録
      this.features = this.$store.getters['marker/features'](this.category);

      if (this.features.length !== 0) {
        // 種別を登録
        this.types = this.isVisible = Object.keys(
          this.$store.getters['marker/types'](this.category)
        );
        this.$store.dispatch('setProgress', 50);
      }
      // 画像タイルレイヤ
      this.tileImage = this.$store.getters['marker/tileImage'](this.category);

      // タイトルを書き換える
      document.title = this.$t(`categories.${this.category}`) + ' - ' + title;
      this.$store.dispatch('setProgress', 70);
      this.redraw();
      // ローディングオーバーレイを閉じる
      this.$store.dispatch('setLoading', false);
      // 切り替え完了のメッセージを出力
      this.$store.dispatch(
        'setMessage',
        this.$t('category-changed', {
          category: this.$t(`categories.${this.category}`),
        })
      );
      // 完了イベント
      this.$emit('ready');
    },
    redraw() {
      this.$emit('redraw');
      if (this.tileImage) {
        // const source = await this.$refs.categoryTileLayer.getSource();
        const source = this.$refs.categoryLayerSource;
        // 新しい画像レイヤを指定
        if (source) {
          source.setUrl('/img/markerTile/' + this.tileImage);
          if (source.tileCache) {
            // 表示されている画像データとキャッシュを削除
            source.tileCache.expireCache({});
            source.tileCache.clear();
          }
          // リフレッシュ
          source.refresh();
        }
      }

      if (this.features.length !== 0) {
        this.$refs.markerLayer.setStyle((features, resolution) =>
          this.setStyle(features, resolution)
        );
      }
    },
    // Apply Marker style.
    setStyle(feature, resolution) {
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
      const types = Object.keys(
        this.$store.getters['marker/types'](this.category)
      );

      const colorset = this.$store.getters['marker/colorset'](this.category);
      // Get color index from type
      const index = types.indexOf(type);

      // Apply marker color
      const style = styles[colorset[index]];
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
};
</script>
