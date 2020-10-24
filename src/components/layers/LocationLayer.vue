<template>
  <!-- Location Marker markers -->
  <vl-layer-vector ref="locationLayer" :z-index="1" :visible="visible">
    <vl-source-vector
      ref="vectorSource"
      :features="features"
      :update-while-animating="true"
      :update-while-interacting="true"
    />
  </vl-layer-vector>
</template>

<script>
/**
 * Location Marker (Icon marker)
 */
export default {
  data() {
    return {
      // center location
      coordinates: [0, 0],
      features: [],
      styles: {},
    };
  },
  computed: {
    // Marker Visibility
    visible() {
      return this.$store.getters['config/displayLocation'];
    },
    // Zoom
    zoom() {
      return this.$store.getters['location/zoom'];
    },
  },
  watch: {
    visible(value) {
      if (value) {
        // 表示するときのみこの処理を動かす
        this.redraw();
      }
    },
    zoom() {
      this.redraw();
    },
  },
  async created() {
    if (this.$store.getters['locationMarker/features'].length === 0) {
      await this.$store.dispatch('locationMarker/init');
    }

    // マーカーを登録
    this.features = this.$store.getters['locationMarker/features'];
    this.styles = this.$store.getters['locationMarker/styles'];
    this.redraw();
  },
  methods: {
    /**
     * Redraw Marker Icon.
     */
    redraw() {
      if (this.features.length === 0) {
        return;
      }
      // マーカーのスタイルを設定
      this.$refs.locationLayer.setStyle((feature, resolution) => {
        // マーカーのタイプをアイコンにする
        const type = feature.get('type');
        // 注釈（現在のところ、地割れ地点のギリシア文字のみ）
        const label = feature.get('label');
        // アイコンのサイズを調整
        const scale =
          this.$parent.getView().getResolutionForZoom(2) / resolution;

        // スタイル定義を取得
        const style = this.$store.getters['locationMarker/style'](type);

        // 注釈を入れる
        style.getText().setText(scale < 1 ? '' : label);

        // リサイズ
        style.getImage().setScale(scale < 1 ? scale : 1);

        return style;
      });
    },
  },
};
</script>
