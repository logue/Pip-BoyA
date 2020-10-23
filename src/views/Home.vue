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
      :renderer="$store.getters['config/webgl'] ? 'webgl' : 'canvas'"
      :max-extent="config.extent"
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
        :extent="config.extent"
      />

      <!-- Base map layers -->
      <base-layer ref="baseLayer" :opacity="1" />
      <!-- Map markers -->
      <location-layer ref="locationLayer" />
      <!-- Category map layer -->
      <category-layer
        ref="categoryLayer"
        :category="$route.params.category"
        @ready="onCategoryLayerReady"
      />
      <!-- Blast Zone -->
      <!--vl-feature>
        <vl-geom-circle
          ref="blastZone"
          :coordinates="coordinatesBlastZone"
          :radius="160"
        />
        <vl-style-box>
          <vl-style-fill
            :color="`rgba(${hexToRgb(blastZoneColorSet.accent1)},0.3)`"
          />
          <vl-style-stroke :color="blastZoneColorSet.accent4" />
        </vl-style-box>
      </vl-feature-->

      <!-- Tooltip Overlay -->
      <vl-overlay
        v-if="showMarkerTooltip"
        ref="tooltipOverlay"
        :auto-pan="true"
        :position="currentPosition"
        :offset="[10, 10]"
      >
        <span class="v-tooltip__content map-viewer_map_tooltip">
          {{ currentName }}
        </span>
      </vl-overlay>

      <!-- detect Select event -->
      <vl-interaction-select ref="selectInteraction" hover @select="onSelect" />
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
    <explain ref="explainPopup" @changed="onMarkerSelectChanged" />
  </div>
</template>

<script>
/**
 * Map Viewer and Explains Component
 */
import colors from 'vuetify/lib/util/colors';

import FullScreen from 'ol/control/FullScreen';
import OverviewMap from 'ol/control/OverviewMap';
import ZoomSlider from 'ol/control/ZoomSlider';
import MousePosition from 'ol/control/MousePosition';
import PinchRotate from 'ol/interaction/PinchRotate';

import {createStringXY} from 'ol/coordinate';

import config from '@/assets/map.config.js';
import {hexToRgb} from '@/assets/utility.js';

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
      hitFeature: null,
      // detect map move
      isMoving: false,
      // Tooltip
      currentPosition: undefined,
      currentName: undefined,
      showMarkerTooltip: false,
      // Blast zone
      coordinatesBlastZone: [0, 0],
      blastZoneColorSet: colors.red,
    };
  },
  mounted() {
    // Load location from QueryString.
    this.center = [
      (this.$route.query.x || config.center[0]) | 0,
      (this.$route.query.y || config.center[1]) | 0,
    ];
    this.zoom = (this.$route.query.z || 1) | 0;
  },
  methods: {
    // マップが読み込まれたとき
    onMapMounted() {
      this.$store.dispatch('setLoading', true);
      const map = this.$refs.map.$map;
      // now ol.Map instance is ready and we can work with it directly
      map.getControls().extend([
        new MousePosition({
          coordinateFormat: createStringXY(0),
        }),
        new FullScreen(),
        new OverviewMap({
          collapsed: true,
          collapsible: true,
        }),
        new ZoomSlider(),
      ]);
      // Disable rotate function.
      const interactions = map.getInteractions().getArray();
      const pinchRotateInteraction = interactions.filter((interaction) => {
        return interaction instanceof PinchRotate;
      })[0];
      pinchRotateInteraction.setActive(false);

      this.$store.dispatch('setLoading', false);
    },
    // マップ移動開始時
    onMoveStart() {
      this.isMoving = true;
    },
    // マップ移動終了時
    onMoveEnd(e) {
      this.isMoving = false;
      // グローバル変数の座標を更新
      this.$store.commit('location/setLocation', {
        x: this.center[0] | 0,
        y: this.center[1] | 0,
        z: this.zoom | 0,
      });
    },
    // ポインタ移動時
    onMapPointerMove(arr) {
      const map = this.$refs.map;
      this.hitFeature = map.forEachFeatureAtPixel(
        arr.pixel,
        (feature) => feature
      );

      if (this.hitFeature) {
        // クリックされたマーカーのプロパティの値を取得
        const name =
          this.hitFeature.get('name') || this.hitFeature.values_.name || null;
        const type =
          this.hitFeature.get('type') || this.hitFeature.values_.type || null;
        const label =
          this.hitFeature.get('label') || this.hitFeature.values_.label || null;

        // ツールチップの描画位置を取得
        this.currentPosition = this.hitFeature.getGeometry().getCoordinates();

        // ツールチップの内容を更新
        this.currentName = name
          ? this.$t(`locations.${name}`)
          : this.$t(`markers.${type}`);
        if (label) {
          this.currentName += ` (${label})`;
        }

        this.showMarkerTooltip = true;
      } else {
        // nullを代入してツールチップを隠す
        this.currentPosition = this.currentName = undefined;
        this.showMarkerTooltip = false;
      }
    },
    // 初期位置に戻る
    resetLocation() {
      this.center = [this.$route.query.x, this.$route.query.y];
      this.zoom = this.$route.query.zoom;
    },
    // マーカーをクリックしたときの処理
    onSelect(e) {
      this.$refs.markerInfo.open(e);
      // TODO: マーカーの選択を解除
      const features = this.$refs.selectInteraction.getFeatures();
      console.info(features);
    },
    // カテゴリレイヤーの描画が完了したとき
    onCategoryLayerReady() {
      console.log('redraw');
      this.$refs.explainPopup.update();
    },
    // 凡例のチェックボックスが変化した時
    onMarkerSelectChanged(selected) {
      // console.log(selected);
      this.$refs.categoryLayer.isVisible = selected;
    },
    hexToRgb(hex) {
      return hexToRgb(hex);
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
        z-index: 0;
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
      &_tooltip {
        transition: $primary-transition;
        white-space: nowrap !important;
        z-index: 1;
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
