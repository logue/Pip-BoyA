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

      <!-- Base map layers -->
      <vl-layer-group ref="baseLayers" :opacity="opacity">
        <vl-layer-tile :visible="!$root.$data.isMilitary">
          <vl-source-xyz
            :url="'/img/tiles/base/{z}/{x}/{y}.webp'"
            :projection="projection"
            :min-zoom="minZoom"
            :max-zoom="maxZoom"
            :tile-pixe-ratio="tilePixelRatio"
          />
        </vl-layer-tile>
        <vl-layer-tile :visible="$root.$data.isMilitary">
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
      >
        <vl-source-xyz
          ref="categoryLayerSource"
          :url="`/img/map/${category}/{z}/{x}/{y}.png`"
          :projection="projection"
          :min-zoom="minZoom"
          :max-zoom="maxZoom"
          :tile-pixe-ratio="tilePixelRatio"
        />
      </vl-layer-tile>

      <!-- markers are bellow -->
    </vl-map>

    <!-- Explain box -->
    <v-card v-if="explains.length !== 0" shaped dark class="explain">
      <v-card-title class="explain_title">
        {{ $t('legend') }}
        <v-spacer />
        <v-btn icon @click="toggleShrink">
          <v-icon v-if="!isShrink">mdi-window-minimize</v-icon>
          <v-icon v-else>mdi-window-maximize</v-icon>
        </v-btn>
      </v-card-title>
      <v-card-text v-if="!isShrink" class="explain_body">
        <ul class="explain_list">
          <li
            v-for="(item, index) in explains"
            :key="index"
            :class="`explain_list_item explain_list_item_${colorset[index]}`"
          >
            {{ $t(item) }}
          </li>
        </ul>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
/**
 * Map Viewer and Explains Component
 */
import {addProjection, get} from 'ol/proj';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';

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

export default {
  props: {
    // カテゴリ
    category: {
      required: false,
      default: null,
      type: String,
    },
    // 凡例
    explains: {
      required: false,
      type: Array,
      default: () => [],
    },
    // マーカーのカラー配列
    colorset: {
      required: false,
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      // View
      zoom: 1,
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
      tileGrid: mapTileGrid,
      tilePixelRatio: 1.0,
      url: '/img/map/base/{z}/{x}/{y}.png',
      // detect map move
      isMoving: false,
      // Base map layer opacity
      opacity: 1,
      // Switch Explain box to maximize and minimize
      isShrink: false,
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
    // カテゴリレイヤーを更新
    updateCategoryLayer() {
      // カテゴリ用レイヤーのソース
      const source = this.$refs.categoryLayer.getSource();
      // 一旦urlをアンロード
      try {
        source.setUrl(null);
      } catch (e) {
        // TODO:
      }
      if (this.category) {
        // カテゴリが指定されている場合
        if (source.tileCache) {
          // 表示されている画像データとキャッシュを削除
          source.tileCache.expireCache({});
          source.tileCache.clear();
        }
        // 新しい画像レイヤを指定
        source.setUrl(`/img/map/${this.category}/{z}/{x}/{y}.png`);
        this.opacity = 0.5;
      } else {
        this.opacity = 1;
      }
      // リフレッシュ
      source.refresh();
    },
    // 初期位置に戻る
    resetLocation() {
      this.center = [this.$route.query.x, this.$route.query.y];
      this.zoom = this.$route.query.zoom;
    },
    // 凡例の表示切り替え
    toggleShrink() {
      this.isShrink = !this.isShrink;
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

// アウトライン生成
@function outline($color, $width, $blur) {
  @return $width $width $blur $color, -$width $width $blur $color,
    $width -$width $blur $color, -$width -$width $blur $color,
    $width 0px $blur $color, 0px $width $blur $color, -$width 0px $blur $color,
    0px -$width $blur $color;
}

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
  }
}

.explain {
  color: map-get($grey, 'lighten-4');
  text-shadow: outline(rgba(map-get($grey, 'darken-4'), 0.5), 1px, 1px);
  position: absolute;
  right: 1rem;
  bottom: 1rem;
  padding: 0.5rem;
  margin: 0;
  z-index: 100;
  &_title {
    padding: 0 0.5rem !important;
  }

  &_body {
    padding: 0;
  }

  &_list {
    padding-inline-start: 1rem;
    list-style-type: '♦ ';
    columns: 2;
    &_item {
      font-size: 0.75rem;

      &_cyan {
        color: cyan;
      }
      &_magenta {
        color: magenta;
      }
      &_yellow {
        color: yellow;
      }
      &_red {
        color: red;
      }
      &_lime {
        color: lime;
      }
      &_blue {
        color: blue;
      }
      &_lightgray {
        color: lightgray;
      }
      &_orange {
        color: orange;
      }
      &_springgreen {
        color: springgreen;
      }
      &_pink {
        color: pink;
      }
      &_purple {
        color: purple;
      }
      &_darkgreen {
        color: darkgreen;
      }
      &_maroon {
        color: maroon;
      }

      // アウトラインカラーを白にする
      &_green,
      &_red,
      &_blue,
      &_darkgreen,
      &_purple,
      &_maroon {
        text-shadow: outline(rgba(map-get($grey, 'lighten-4'), 0.5), 1px, 1px);
      }
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
  .explain {
    background-color: rgba(map-get($grey, 'lighten-1'), 0.7);
  }
}

.theme--dark {
  .map-viewer {
    background-color: map-get($grey, 'darken-4');
    .ol-control {
      background-color: rgba(map-get($grey, 'darken-3'), 0.7);
    }
  }
  .explain {
    background-color: rgba(map-get($grey, 'darken-3'), 0.7);
  }
}
</style>
