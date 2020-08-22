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
        :center.sync="center"
        :rotation.sync="rotation"
        :projection="config.projection"
        :resolutions="config.resolutions"
      />

      <!-- Base map layers -->
      <base-layer ref="baseLayer" :opacity="1" />

      <!-- Category map layer -->
      <category-layer
        ref="categoryLayer"
        category="nw-flatwoods"
        @changed="onCategoryChanged"
      />

      <!-- Map markers -->
      <location-layer
        v-if="$root.$data.displayLocation"
        ref="locationLayer"
        @marker-select="onSelect"
      />

      <!-- Tooltip Overlay -->
      <vl-overlay
        v-if="showMarkerTooltip"
        :position="currentPosition"
        :offset="[10, 10]"
        class="markerTooltipOverlay"
      >
        <span class="v-tooltip__content" style="white-space: nowrap;">
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

import BaseLayer from '@/components/layers/BaseLayer.vue';
import CategoryLayer from '@/components/layers/CategoryLayer.vue';
import LocationLayer from '@/components/layers/LocationLayer.vue';
import MarkerInfo from '@/components/MarkerInfo.vue';
import Explain from '@/components/Explain.vue';

export default {
  components: {
    'marker-info': MarkerInfo,
    'base-layer': BaseLayer,
    'category-layer': CategoryLayer,
    'location-layer': LocationLayer,
    explain: Explain,
  },
  data() {
    return {
      config: config,
      // View
      zoom: 1,
      center: config.center,
      rotation: 0,
      opacity: 1,
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
  watch: {
    zoom() {
      if (this.$root.$data.displayLocation) {
        // ズームの値によってロケーションアイコンのサイズを変える
        this.$refs.locationLayer.setScale(this.zoom);
      }
    },
    $route(to) {
      this.$root.$data.loading = true;
      // カテゴリレイヤーを初期化
      this.$refs.categoryLayer.category = null;
      this.$refs.explainPopup.updateExplain({});
      this.$refs.baseLayer.opacity = 1;
      this.explains = {};

      this.category = to.params.category || null;
      this.changeCategory();

      this.$root.$data.loading = false;
    },
  },
  mounted() {
    // Load location from QueryString.
    this.center = [
      (this.$route.query.x ?? config.center[0]) | 0,
      (this.$route.query.y ?? config.center[1]) | 0,
    ];
    this.zoom = (this.$route.query.z ?? 1) | 0;

    if (this.$root.$data.displayLocation) {
      // ズームの値によってロケーションアイコンのサイズを変える
      this.$refs.locationLayer.setScale(this.zoom);
    }
    if (this.$route.params.category) {
      this.category = this.$route.params.category;
      this.changeCategory();
    }
    this.$root.$data.loading = false;
  },
  methods: {
    async changeCategory() {
      // カテゴリが存在しない場合はここで終了
      if (!this.category) {
        return;
      }
      // カテゴリが存在する場合、カテゴリの凡例データの含まれたjsonから凡例の項目とカラーセットを取得
      const response = await this.axios
        .get(`/data/${this.category}.json`)
        .catch((err) => {
          console.error(err.message);
          throw new Error(
            `${this.category}.json does not readable or not found.`
          );
        });

      // console.log(response.data);
      // カテゴリレイヤーを更新
      this.$refs.categoryLayer.category = this.category;
      this.$refs.categoryLayer.updateCategoryLayer(response.data);
      // 凡例レイヤーを更新
      this.$refs.explainPopup.updateExplain({...response.data.explains});
      this.explains = {...response.data.explains};
    },
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
            : this.$t(this.explains[hitFeature.get('type')]) +
              (hitFeature.get('annotation') !== undefined
                ? ` (${hitFeature.get('annotation')})`
                : '');
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
      // 画像マーカーモードのときはベースマップの透過度を半分にする
      this.$refs.baseLayer.opacity = tileMarkerMode ? 0.5 : 1;
    },
  },
};
</script>

<style lang="scss">
@import '~vuetify/src/styles/styles.sass';

// クロスヘアーの色
$crosshairs-color: map-get($red, 'base');
// クロスヘアーの太さ
$crosshairs-width: 0.2rem;
// クロスヘアーの長さ
$crosshairs-length: 1.5rem;

.ol-mouse-position {
  color: map-get($amber, 'base');
  left: 3rem !important;
}

.map-container {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  bottom: 0;
  .map-viewer {
    width: inherit;
    height: inherit;

    &_opacity-slider {
      width: 8rem;
      z-index: 1;
      top: 0.5rem;
      right: 3.5rem;
      position: absolute;
    }

    &_map {
      > :after,
      > :before {
        position: absolute;
        transition-property: opacity;
        transition-duration: 0.25s;
        background-color: $crosshairs-color;
        mix-blend-mode: hard-light;
        content: '';
        display: block;
        opacity: 1;
      }
      > :before {
        top: calc(50% - #{$crosshairs-width / 2});
        left: calc(50% - #{$crosshairs-length / 2});
        width: $crosshairs-length;
        height: $crosshairs-width;
      }
      > :after {
        top: calc(50% - #{$crosshairs-length / 2});
        left: calc(50% - #{$crosshairs-width / 2});
        width: $crosshairs-width;
        height: $crosshairs-length;
      }
      // ドラッグ中はクロスヘアーを薄くする
      &.is_move {
        > :after,
        > :before {
          opacity: 0.5;
        }
      }
      // マーカーホバー時にカーソルをポインタにする
      &.is_hover {
        cursor: pointer;
      }
    }
  }
}

.theme--light {
  .map-container {
    .map-viewer {
      background-color: map-get($grey, 'lighten-1');
    }
    .ol-control {
      transition: $primary-transition;
      background-color: rgba(map-get($grey, 'lighten-2'), 0.5);
      button {
        background-color: rgba(map-get($blue, 'darken-3'), 0.5);
      }
    }
    .ol-control:hover {
      background-color: rgba(map-get($grey, 'lighten-2'), 0.7);
      button:hover {
        background-color: map-get($blue, 'darken-3');
      }
    }
    .ol-overviewmap .ol-overviewmap-map {
      border-color: map-get($blue, 'darken-3');
    }
  }
}

.theme--dark {
  .map-container {
    .map-viewer {
      background-color: map-get($grey, 'darken-4');
    }
    .ol-control {
      transition: $primary-transition;
      background-color: rgba(map-get($grey, 'darken-3'), 0.5);
      button {
        background-color: rgba(map-get($blue, 'base'), 0.5);
      }
    }
    .ol-control:hover {
      background-color: rgba(map-get($grey, 'darken-3'), 0.7);
      button:hover {
        background-color: map-get($blue, 'darken-3');
      }
    }
    .ol-overviewmap .ol-overviewmap-map {
      border-color: map-get($blue, 'lighten-4');
    }
  }
}
</style>
