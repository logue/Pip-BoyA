<template>
  <v-card class="map-viewer">
    <v-system-bar lights-out absolute class="map-viewer_system-bar">
      <span class="mr-2">
        <v-icon>mdi-relative-scale</v-icon>
        {{ (zoom | 0 )}}
      </span>
      <span class="mr-2">
        <v-icon>mdi-crosshairs-gps</v-icon>
        {{ [center[0] | 0, center[1] | 0] }}
      </span>
    </v-system-bar>

    <v-tooltip bottom>
      <template #activator="{on, attrs}">
        <v-slider
          v-model="opacity"
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

    <!-- app map -->
    <vl-map
      ref="map"
      :class="`map-viewer_map${isMoving ? ' is_move' : ''}`"
      :load-tiles-while-animating="true"
      :load-tiles-while-interacting="true"
      @movestart="onMoveStart"
      @moveend="onMoveEnd"
    >
      <vl-view
        ref="view"
        :zoom.sync="zoom"
        :center.sync="center"
        :rotation.sync="rotation"
        :projection="viewProjection"
        :resolutions="resolutions"
      />

      <vl-layer-group :opacity="opacity">
        <vl-layer-tile :visible="!$root.$data.isMilitary">
          <vl-source-xyz
            :url="'/img/map/base/{z}/{x}/{y}.png'"
            :projection="projection"
            :min-zoom="minZoom"
            :max-zoom="maxZoom"
            :tile-pixe-ratio="tilePixelRatio"
          />
        </vl-layer-tile>
        <vl-layer-tile :visible="$root.$data.isMilitary">
          <vl-source-xyz
            :url="'/img/map/military/{z}/{x}/{y}.png'"
            :projection="projection"
            :min-zoom="minZoom"
            :max-zoom="maxZoom"
            :tile-pixe-ratio="tilePixelRatio"
          />
        </vl-layer-tile>
      </vl-layer-group>
      <vl-layer-tile v-if="category" ref="category">
        <vl-source-xyz
          :url="`/img/map/${category}/{z}/{x}/{y}.png`"
          :projection="projection"
          :min-zoom="minZoom"
          :max-zoom="maxZoom"
          :tile-pixe-ratio="tilePixelRatio"
        />
      </vl-layer-tile>
    </vl-map>
  </v-card>
</template>

<script>
import {addProjection, get} from 'ol/proj';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';

const mapExtent = [0.0, -4096.0, 4096.0, 0.0];
const mapMinZoom = 1;
const mapMaxZoom = 4;
const mapMaxResolution = 0.5;
const tileExtent = [0.0, -4096.0, 4096.0, 0.0];

const mapResolutions = [];
for (let z = 0; z <= mapMaxZoom; z++) {
  mapResolutions.push(Math.pow(2, mapMaxZoom - z) * mapMaxResolution);
}
const mapTileGrid = new TileGrid({
  extent: tileExtent,
  minZoom: mapMinZoom,
  resolutions: mapResolutions,
});

const customProj = new Projection({
  code: 'custom',
  units: 'pixels',
  extent: tileExtent,
});
addProjection(customProj);

export default {
  props: {
    category: {
      required: false,
      default: null,
      type: String,
    },
  },
  emits: ['move'],
  data() {
    this.$root.$data.isMilitary = false;
    return {
      // View
      zoom: 2,
      center: [2048, -2048],
      rotation: 0,
      minResolution: 1,
      maxResolution: 4,
      extent: mapExtent,
      minZoom: mapMinZoom,
      maxZoom: mapMaxZoom,
      resolutions: mapResolutions,
      viewProjection: get('PIXELS'),
      // Map Tile
      projection: customProj.getCode(),
      attributions: '2076 Vault-tec.',
      tileGrid: mapTileGrid,
      tilePixelRatio: 1.0,
      url: '/img/map/base/{z}/{x}/{y}.png',
      // other
      isMoving: false,
      opacity: 1,
    };
  },
  methods: {
    onMoveStart() {
      this.isMoving = true;
    },
    onMoveEnd(e) {
      this.isMoving = false;
      this.$emit('move', {
        x: this.center[0] | 0,
        y: this.center[1] | 0,
        zoom: this.zoom | 0,
      });
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

.map-viewer {
  .ol-zoom {
    top: 2rem !important;
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
    position: absolute;
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
  }
}
</style>
