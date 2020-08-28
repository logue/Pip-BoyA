<template>
  <div class="map-container">
    <!-- Map Container -->
    <vl-map
      ref="map"
      :class="`map-viewer_map${isMoving ? ' is_move' : ''}${
        currentPosition ? ' is_hover' : ''
      }`"
      :load-tiles-while-animating="true"
      :load-tiles-while-interacting="true"
      @mounted="onMapMounted"
      @pointermove="onMapPointerMove"
      @movestart="onMoveStart"
      @moveend="onMoveEnd"
    >
      <vl-view
        ref="view"
        :zoom.sync="zoom"
        :center="center"
        :rotation="rotation"
        :projection="config.projection"
        :resolutions="config.resolutions"
      />

      <!-- Base map layers -->
      <vl-layer-tile ref="baseLayer" :z-index="0">
        <vl-source-xyz
          :url="'/img/tiles/flatwoods/{z}/{x}/{y}.webp'"
          :projection="config.projection"
          :min-zoom="config.minZoom"
          :max-zoom="config.maxZoom"
          :tile-pixe-ratio="config.tilePixelRatio"
        />
      </vl-layer-tile>

      <!-- Category map layer -->
      <category-layer
        ref="categoryLayer"
        category="nw-flatwoods"
        @changed="onCategoryChanged"
      />

      <!-- Tooltip Overlay -->
      <vl-overlay
        v-if="showMarkerTooltip"
        :position="currentPosition"
        :offset="[10, 10]"
        class="markerTooltipOverlay"
      >
        <span class="v-tooltip__content" style="white-space: nowrap">
          {{ currentName }}
        </span>
      </vl-overlay>
    </vl-map>
    <!-- opacity slider -->
    <v-tooltip bottom>
      <template #activator="{on, attrs}">
        <v-slider
          v-model="$refs.baseLayer.opacity"
          step="0.1"
          min="0.1"
          max="1"
          class="map-viewer_opacity-slider"
          v-bind="attrs"
          v-on="on"
        />
      </template>
      <span>{{ $t('opacity') }}</span>
    </v-tooltip>
    <marker-info ref="markerInfo" />
    <explain ref="explainPopup" />
  </div>
</template>

<script>
/**
 * Map Viewer and Explains Component
 */
import FullScreen from 'ol/control/FullScreen';
import OverviewMap from 'ol/control/OverviewMap';
import ZoomSlider from 'ol/control/ZoomSlider';
import MousePosition from 'ol/control/MousePosition';

import {createStringXY} from 'ol/coordinate';

import config from '@/assets/map.config.js';

import CategoryLayer from '@/components/layers/CategoryLayer.vue';
import MarkerInfo from '@/components/MarkerInfo.vue';
import Explain from '@/components/Explain.vue';

export default {
  components: {
    'marker-info': MarkerInfo,
    'category-layer': CategoryLayer,
    explain: Explain,
  },
  data() {
    return {
      config: config,
      // View
      zoom: 1,
      center: config.center,
      rotation: 0,
      // detect map move
      isMoving: false,
      // Tooltip
      currentPosition: undefined,
      currentName: undefined,
      showMarkerTooltip: false,
      mapCursor: 'default',
      category: null,
    };
  },
  mounted() {
    this.$refs.categoryLayer.category = 'nw-flatwoods';
    // Load location from QueryString.
    this.center = [
      (this.$route.query.x ?? config.center[0]) | 0,
      (this.$route.query.y ?? config.center[1]) | 0,
    ];
    this.zoom = (this.$route.query.z ?? 1) | 0;
  },
  methods: {
    // マップが読み込まれたとき
    onMapMounted() {
      // now ol.Map instance is ready and we can work with it directly
      this.$refs.map.$map.getControls().extend([
        new FullScreen(),
        new OverviewMap({
          collapsed: true,
          collapsible: true,
        }),
        new ZoomSlider(),
        new MousePosition({
          coordinateFormat: createStringXY(0),
        }),
      ]);

      // console.log(this.config.extent, this.$refs.map.$map.getSize());
      this.$refs.map.$map
        .getView()
        .fit(this.config.extent, this.$refs.map.$map.getSize());
      this.$root.$data.loading = false;
    },
    // マップ移動開始時
    onMoveStart() {
      this.isMoving = true;
    },
    // マップ移動終了時
    onMoveEnd(e) {
      this.isMoving = false;
      // グローバル変数の座標を更新
      this.$root.$data.location = {
        x: this.center[0] | 0,
        y: this.center[1] | 0,
        z: this.zoom | 0,
      };
    },
    // ポインタ移動時
    onMapPointerMove({pixel}) {
      const map = this.$refs.map;
      const hitFeature = map.forEachFeatureAtPixel(pixel, (feature) => feature);
      this.showMarkerTooltip = hitFeature !== undefined;
      if (hitFeature) {
        // ツールチップの描画位置を取得
        this.currentPosition = hitFeature.getGeometry().getCoordinates();
        // ツールチップの内容を更新
        this.currentName =
          hitFeature.get('name') !== undefined
            ? this.$t(`locations.${hitFeature.get('name')}`)
            : hitFeature.get('type');
      } else {
        // nullを代入してツールチップを隠す
        this.currentPosition = this.currentName = undefined;
      }
    },
    // 初期位置に戻る
    resetLocation() {
      this.center = [this.$route.query.x, this.$route.query.y];
      this.zoom = this.$route.query.zoom;
    },
    // マーカーをクリックしたときの処理
    onSelect(value) {
      this.$refs.markerInfo.open(value);
    },
    onCategoryChanged(tileMarkerMode) {
      this.$refs.baseLayer.opacity = 1;
    },
  },
};
</script>
