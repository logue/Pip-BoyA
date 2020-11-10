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
      <vl-source-vector
        :features="features"
        :update-while-animating="true"
        :update-while-interacting="true"
      />
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script>
import config from '@/assets/map.config.js';

/**
 * Category Marker
 * (Tile based marker and coordinate based marker.)
 */
export default {
  data() {
    return {
      // Markers
      features: [],
      // types
      types: [],
      // Marker Visibility
      isVisible: [],
      // Map Configure
      config: config,
      // Color Configure
      colorset: [],
      // use marker tile
      tileImage: false,

      key: 0,
      distance: 40,
    };
  },
  computed: {
    // Zoom
    zoom() {
      return this.$store.getters['location/zoom'];
    },
    category() {
      return this.$route.params.category;
    },
  },
  watch: {
    /**
     * When Page transition
     * @param {*} to new route
     */
    $route(to) {
      this.init();
    },
    /**
     * When marker changed.
     */
    features() {
      this.key++;
    },
    /**
     * When switch change visibility
     */
    isVisible() {
      // 表示マーカーの設定が変化したとき
      this.$refs.markerLayer.setStyle((features, resolution) =>
        this.setStyle(features, resolution)
      );
    },
    /**
     * When change map scale
     */
    zoom() {
      this.redraw();
    },
  },
  created() {
    // マーカースタイルを定義
    this.$store.dispatch('marker/init');
  },
  mounted() {
    this.init();
  },
  methods: {
    /**
     * Initialize category markers.
     * @return {void}
     */
    async init() {
      await this.$store.dispatch('setLoading', true);
      await this.$forceNextTick();
      // タイトルを変更
      const title = process.env.IS_ELECTRON
        ? this.$t('title').replace(/Web/g, 'Electron')
        : this.$t('title');

      if (!this.category) {
        // カテゴリ別のページでない場合、表示中のマーカーを削除して終了
        document.title = title;
        this.features = [];
        this.$store.dispatch('setLoading', false);
        return 2;
      }

      await this.$store.dispatch('setProgress', 20);
      await this.$forceNextTick();
      // マーカーを登録
      this.features = this.$store.getters['marker/features'](this.category);

      await this.$store.dispatch('setProgress', 50);
      await this.$forceNextTick();
      if (this.features) {
        // 種別を登録
        this.types = this.isVisible = this.$store.getters['marker/items'](
          this.category
        );
      }
      // 画像タイルレイヤ
      this.tileImage = this.$store.getters['marker/tileImage'](this.category);
      // タイトルを書き換える
      document.title = this.$t(`categories.${this.category}`) + ' - ' + title;

      await this.$store.dispatch('setProgress', 70);
      await this.$forceNextTick();
      // 再描画
      this.redraw();

      await this.$store.dispatch('setProgress', 100);
      // ローディングオーバーレイを閉じる
      await this.$store.dispatch('setLoading', false);
      await this.$forceNextTick();

      // 切り替え完了のメッセージを出力
      this.$store.dispatch(
        'setMessage',
        this.$t('category-changed', {
          category: this.$t(`categories.${this.category}`),
        })
      );
    },
    /**
     * Redraw map markers and map tiles.
     */
    redraw() {
      if (this.tileImage) {
        const source = this.$refs.categoryTileLayer.getSource();
        // const source = this.$refs.categoryLayerSource;
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
      if (this.features) {
        this.$refs.markerLayer.setStyle((features, resolution) =>
          this.setStyle(features, resolution)
        );
      }
    },
    /**
     * Apply Marker style.
     * @param {ol.Feature} feature Marker
     * @param {number} resolution Map zoom
     * @return {ol.style.Style}
     */
    setStyle(feature, resolution) {
      // Get Marker type
      const type = feature.get('type');
      // Get all type list.
      const items = this.$store.getters['marker/items'](this.category);

      const colorset = this.$store.getters['marker/colorset'](this.category);
      // Get color index from type
      const index = Object.values(items).indexOf(type);

      // Apply marker color
      const style = this.$store.getters['marker/style'](colorset[index]);
      // Map zoom
      const scale = this.$parent.getView().getResolutionForZoom(2) / resolution;

      // Add label to marker
      const label = feature.values_.label
        ? feature.values_.label.toString()
        : '';

      // apply label text
      style.getText().setText(label && scale >= 1 ? label : '');

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
