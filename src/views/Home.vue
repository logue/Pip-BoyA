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
      <base-layer />

      <!-- Category map layer -->
      <category-layer
        :category="$route.params.category"
        @changed="onCategoryChanged"
      />

      <!-- Map markers -->
      <location-layer ref="locationLayer" @marker-select="onSelect" />

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
    <marker-info ref="markerInfo" />
    <explain v-if="explains" :explains="explains" />
  </div>
</template>

<script>
/**
 * Map Viewer and Explains Component
 */
import FullScreen from 'ol/control/FullScreen';
import OverviewMap from 'ol/control/OverviewMap';
import ZoomSlider from 'ol/control/ZoomSlider';

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
      this.$refs.locationLayer.setScale(this.zoom);
    },
    '$root.$data.displayLocation'() {
      // console.log(this.$refs.locationLayer);
      // this.$refs.locationLayer.toggleVisible(this.$root.$data.displayLocation);
    },
    $route(to) {
      if (to.name === 'Category') {
        this.category = to.params.category;
      } else {
        this.category = null;
      }
    },
  },
  async mounted() {
    // Load location from QueryString.
    this.center = [
      (this.$route.query.x ?? config.center[0]) | 0,
      (this.$route.query.y ?? config.center[1]) | 0,
    ];
    this.zoom = (this.$route.query.z ?? 1) | 0;

    this.$refs.locationLayer.setScale(this.zoom);

    this.$root.$data.loading = false;
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
      console.log(value);
      // this.$refs.markerInfo.marker = value;
      this.$refs.markerInfo.open(value);
    },
    onCategoryChanged(explains) {
      this.explains = explains;
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
.map-container {
  height: 99%;
  .map-viewer {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    bottom: 0;

    .ol-mouse-position {
      color: map-get($red, 'base');
    }

    &_system-bar {
      z-index: 1;
    }
    &_opacity-slider {
      width: 8rem;
      z-index: 1;
      top: 2rem;
      right: 1rem;
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
