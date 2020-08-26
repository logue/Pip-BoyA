<template>
  <vl-layer-group
    v-if="category"
    :opacity="1"
    :z-index="2"
    class="category-layer"
  >
    <vl-layer-tile v-if="features.length === 0">
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
    <!-- location based marker mode -->
    <vl-layer-vector ref="markerLayer">
      <vl-source-vector :features.sync="features"></vl-source-vector>
    </vl-layer-vector>
  </vl-layer-group>
</template>

<script>
import config from '@/assets/map.config.js';
import colorset from '@/assets/colorset.json';
import {convertGeoJson, createMarkerStyle, valuesOf} from '@/assets/utility.js';

const styles = createMarkerStyle();

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
      // Markers
      features: [],
      // types
      types: [],
      // Explain definition
      explains: {},
      // Map Configure
      config: config,
      // Color Configure
      set: colorset,
      // Marker Visibiloty
      visible: {},
    };
  },
  watch: {
    $route(to) {
      this.category = to.params.category;
      this.onLoad();
    },
  },
  mounted() {
    this.onLoad();
  },
  methods: {
    onLoad() {
      this.$root.$data.loading = true;

      this.loadFeatures().then((features) => {
        if (features.length !== 0) {
          this.features = features.map(Object.freeze);
        }
        this.redraw();
        this.$root.$data.loading = false;
      });
    },
    // マーカーを追加
    async loadFeatures() {
      const locations = await this.axios
        .get(`/data/${this.$route.params.category}.json`)
        .catch((err) => {
          console.error(err);
        });
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
      return convertGeoJson(locations.data.markers, config.center);
    },
    async redraw() {
      // const source = this.$refs.categoryLayer.getSource();
      const source = this.$refs.categoryLayerSource;

      if (source) {
        // 新しい画像レイヤを指定
        try {
          source.setUrl(
            `/img/markerTile/${this.$route.params.category}/{z
            }/{x}/{y}.png`
          );
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
      } else {
        // console.log(this.$refs.markerLayer);
        await this.$refs.markerLayer.setStyle((features) =>
          this.setStyle(features)
        );
      }
    },
    setStyle(feature) {
      // マーカーのタイプを色のインデックスにする
      const index = this.types.indexOf(feature.get('type'));
      const style = valuesOf(styles)[index];
      if (feature.get('label')) {
        style.getText().setText(feature.get('label').toString());
      } else {
        style.getText().setText('');
      }
      return style;
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
  },
};
</script>
