<template>
  <div class="map-viewer">
    <!-- System Bar -->
    <v-system-bar lights-out absolute class="map-viewer_system-bar">
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <span class="mr-2" v-bind="attrs" v-on="on">
            <v-icon>mdi-relative-scale</v-icon>
            {{ (zoom | 0 )}}
          </span>
        </template>
        <span>{{ $t('zoom') }}</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <span class="mr-2" v-bind="attrs" v-on="on">
            <v-icon>mdi-crosshairs-gps</v-icon>
            {{ [center[0] | 0, center[1] | 0] }}
          </span>
        </template>
        <span>{{ $t('projection') }}</span>
      </v-tooltip>
    </v-system-bar>
    <!-- Base map opacity slider -->
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
    <!-- Map Container -->
    <vl-map
      ref="map"
      :class="`map-viewer_map${isMoving ? ' is_move' : ''}${
        currentPosition ? ' is_hover' : ''
      }`"
      :load-tiles-while-animating="true"
      :load-tiles-while-interacting="true"
      @movestart="onMoveStart"
      @moveend="onMoveEnd"
      @pointermove="onMapPointerMove"
    >
      <vl-view
        ref="view"
        :zoom.sync="zoom"
        :center.sync="center"
        :rotation.sync="rotation"
        :projection="viewProjection"
        :resolutions="resolutions"
      />

      <!-- Base map layers -->
      <vl-layer-group ref="baseLayers" :opacity="opacity">
        <vl-layer-tile :visible="!$root.$data.isMilitary" :z-index="0">
          <vl-source-xyz
            :url="'/img/tiles/base/{z}/{x}/{y}.webp'"
            :projection="projection"
            :min-zoom="minZoom"
            :max-zoom="maxZoom"
            :tile-pixe-ratio="tilePixelRatio"
          />
        </vl-layer-tile>
        <vl-layer-tile :visible="$root.$data.isMilitary" :z-index="1">
          <vl-source-xyz
            :url="'/img/tiles/military/{z}/{x}/{y}.webp'"
            :projection="projection"
            :min-zoom="minZoom"
            :max-zoom="maxZoom"
            :tile-pixe-ratio="tilePixelRatio"
          />
        </vl-layer-tile>
      </vl-layer-group>

      <!-- Category map layer -->
      <vl-layer-tile
        ref="categoryLayer"
        :visible="category !== null"
        :opacity="1"
        :z-index="2"
      >
        <vl-source-xyz
          v-if="!data.markers"
          ref="categoryLayerSource"
          :url="`/img/markerTile/${category}/{z}/{x}/{y}.png`"
          :projection="projection"
          :min-zoom="minZoom"
          :max-zoom="maxZoom"
          :tile-pixe-ratio="tilePixelRatio"
        />
        <vl-feature
          v-for="marker in data.markers"
          v-else
          :key="marker.id"
          :properties="marker"
        >
          <vl-geom-point
            :coordinates="convertCoordinates(marker.x, marker.y)"
          />
          <vl-style-box>
            <vl-style-circle>
              <vl-style-stroke :color="getMarkerColor(marker.type).base" />
              <vl-style-fill
                :color="`rgba(${hexToRgb(
                  getMarkerColor(marker.type).lighten5
                ).join(',')},0.3
                  )`"
              />
            </vl-style-circle>
          </vl-style-box>
        </vl-feature>
      </vl-layer-tile>

      <!-- Map markers -->
      <vl-layer-vector v-if="$root.$data.displayLocation" ref="featuresLayer">
        <vl-feature
          v-for="marker in markers"
          :key="marker.id"
          :properties="marker"
        >
          <vl-geom-point
            :coordinates="convertCoordinates(marker.x, marker.y)"
          />
          <vl-style-box>
            <vl-style-icon
              :src="`/img/marker/${marker.type}.svg`"
              :img-size="[32, 32]"
              :scale="setMarkerScaleByZoom()"
              cross-origin="anonymous"
            />
          </vl-style-box>
        </vl-feature>
      </vl-layer-vector>

      <vl-interaction-select @select="onSelect" />

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

    <!-- Explain box -->
    <explain v-if="category" :explains="{...data.explains}" />
    <marker-info v-if="$root.$data.displayLocation" ref="markerInfo" />
  </div>
</template>

<script>
/**
 * Map Viewer and Explains Component
 */
import colors from 'vuetify/lib/util/colors';

import {addProjection, get} from 'ol/proj';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';

import MarkerInfo from '@/components/MarkerInfo.vue';
import Explain from '@/components/Explain.vue';

import locations from '@/assets/locations.json';
import colorset from '@/assets/colorset.json';

// Map Configure
const mapExtent = [0.0, -4096.0, 4096.0, 0.0];
const mapMinZoom = 0;
const mapMaxZoom = 4;
const mapMaxResolution = 0.5;
const tileExtent = [0.0, -4096.0, 4096.0, 0.0];

const mapResolutions = [];
for (let z = mapMinZoom; z <= mapMaxZoom; z++) {
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

// Offset Configure
const COORDINATES_CENTER = [2048, -2048];
// Fallout76 coordinates to pixel coordinates pixel rate.
const COORDINATES_REDUCTION_RATE = 142; // WTF?

export default {
  components: {
    'marker-info': MarkerInfo,
    explain: Explain,
  },
  props: {
    // カテゴリ
    category: {
      required: false,
      default: null,
      type: String,
    },
    // カテゴリのデータ
    data: {
      required: false,
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      // View
      zoom: 1,
      center: COORDINATES_CENTER,
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
      tileGrid: mapTileGrid,
      tilePixelRatio: 1.0,
      // detect map move
      isMoving: false,
      // Base map layer opacity
      opacity: 1,
      // Marker setting
      markers: locations.markers,
      // Tooltip
      currentPosition: undefined,
      currentName: undefined,
      showMarkerTooltip: false,
      mapCursor: 'default',
    };
  },
  watch: {
    // カテゴリ変更時に読み込む画像を変更
    category() {
      this.updateCategoryLayer();
    },
  },
  mounted() {
    // Load location from QueryString.
    this.center = [
      (this.$route.query.x ?? 2048) | 0,
      (this.$route.query.y ?? -2048) | 0,
    ];
    this.zoom = (this.$route.query.z ?? 1) | 0;
  },
  methods: {
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
    // カテゴリレイヤーを更新
    updateCategoryLayer() {
      this.opacity = 1;
      if (!this.category) {
        this.explains = null;
        return;
      }
      this.$root.$data.loading = true;

      // 凡例を書き換え
      this.explains = this.data.explains;

      if (!this.data.markers) {
        // 画像マーカーモード
        this.opacity = 0.5;

        const source = this.$refs.categoryLayer.getSource();
        // 一旦urlをアンロード
        try {
          source.setUrl(null);
        } catch (e) {
          // TODO:
        }

        if (source.tileCache) {
          // 表示されている画像データとキャッシュを削除
          source.tileCache.expireCache({});
          source.tileCache.clear();
        }

        // 新しい画像レイヤを指定
        source.setUrl(`/img/map/${this.category}/{z}/{x}/{y}.png`);
        // リフレッシュ
        source.refresh();
      } else {
        // ポイントマーカーモード
        this.opacity = 1;
      }
      this.$root.$data.loading = false;
    },
    // 初期位置に戻る
    resetLocation() {
      this.center = [this.$route.query.x, this.$route.query.y];
      this.zoom = this.$route.query.zoom;
    },
    // 座標系を変換
    convertCoordinates(x, y) {
      return [
        x / COORDINATES_REDUCTION_RATE + COORDINATES_CENTER[0],
        y / COORDINATES_REDUCTION_RATE + COORDINATES_CENTER[1],
      ];
    },
    // ズームサイズによってマーカーのサイズを変更する
    setMarkerScaleByZoom() {
      switch (this.zoom | 0) {
        case 0:
          return 0.5;
        case 1:
          return 0.75;
        case 2:
          return 1;
        case 3:
          return 1.25;
        case 4:
          return 1.5;
      }
      if (this.zoom === 0) {
        return 0.5;
      } else if (this.zoom === 1) {
        return 0.75;
      }
      return 1;
    },
    // マーカーをクリックしたときの処理
    onSelect(feature) {
      const value = feature.values_;
      this.$refs.markerInfo.$props.marker = value;
      this.$refs.markerInfo.open();
    },
    // マーカーの色
    getMarkerColor(type) {
      // 凡例のインデックスを取得
      const index = Object.keys(this.data.explains).findIndex(
        (element) => element === type
      );
      // インデックスからVuetifyで定義されている色を取得
      const color = colorset.markerColor[index];
      // キャメルケースに変換してカラーをVuetifyから取得
      // console.log(colors[this.camelCase2KebabCase(color)].base);
      return colors[this.camelCase2KebabCase(color)];
    },
    // Hex指定の色をrgbの配列に変換する（マーカーの塗りつぶし色用）
    hexToRgb(hex) {
      return hex
        .replace(
          /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
          (m, r, g, b) => '#' + r + r + g + g + b + b
        )
        .substring(1)
        .match(/.{2}/g)
        .map((x) => parseInt(x, 16));
    },
    // キャメルケースをケバブケースに変える（色指定用）
    camelCase2KebabCase(s) {
      return s.replace(/-./g, (x) => x.toUpperCase()[1]);
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
  position: absolute;
  width: 100%;
  height: 100%;
  .ol-zoom {
    top: 2rem;
  }
  .ol-control {
    button {
      background-color: rgba(map-get($blue, 'base'), 0.5);
    }
    button:hover,
    button:focus {
      background-color: rgba(map-get($blue, 'darken-3'), 0.5);
    }
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

.theme--light {
  .map-viewer {
    background-color: map-get($grey, 'lighten-4');
    .ol-control {
      background-color: rgba(map-get($grey, 'lighten-3'), 0.7);
    }
  }
}

.theme--dark {
  .map-viewer {
    background-color: map-get($grey, 'darken-4');
    .ol-control {
      background-color: rgba(map-get($grey, 'darken-3'), 0.7);
    }
  }
}
</style>
