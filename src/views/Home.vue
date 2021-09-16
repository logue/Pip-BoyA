<template>
  <div class="map-container">
    <!-- Map Container -->
    <vl-map
      ref="map"
      :class="mapClass"
      :load-tiles-while-animating="true"
      :load-tiles-while-interacting="true"
      :renderer="renderer"
      :max-extent="extent"
      @mounted="onMapMounted"
      @pointermove="onMapPointerMove"
      @movestart="onMoveStart"
      @moveend="onMoveEnd"
    >
      <vl-view
        ref="view"
        :zoom.sync="zoom"
        :center.sync="currentPosition"
        :rotation.sync="rotation"
        :projection.sync="projection"
        :resolutions.sync="resolutions"
        :extent="extent"
      />

      <!-- Base map layers -->
      <base-layer ref="baseLayer" />
      <!-- Map markers -->
      <location-layer ref="locationLayer" />
      <!-- Category map layer -->
      <category-layer ref="categoryLayer" />
      <!-- Blast Zone -->
      <!--vl-feature>
        <vl-geom-circle
          ref="blastZone"
          :coordinates="coordinatesBlastZone"
          :radius="160"
        />
        <vl-style-box>
          <vl-style-fill :color="blastZoneFillColor" />
          <vl-style-stroke :color="blastZoneColorSet.accent4" />
        </vl-style-box>
      </vl-feature-->

      <!-- Tooltip Overlay -->
      <vl-overlay
        v-if="showMarkerTooltip"
        ref="tooltipOverlay"
        :auto-pan="false"
        :position="position"
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
      <template #activator="{ on, attrs }">
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

<script lang="ts">
/**
 * Map Viewer and Explains Component
 */
import { Component, Vue } from 'vue-property-decorator';
import colors from 'vuetify/lib/util/colors';
// openlayers
import { FullScreen, MousePosition, OverviewMap, ZoomSlider } from 'ol/control';
import { Coordinate, createStringXY } from 'ol/coordinate';
import { Extent, getCenter } from 'ol/extent';
import { FeatureLike } from 'ol/Feature';
import { Interaction, PinchRotate } from 'ol/interaction';
import Map from 'ol/Map';
import MapBrowserEvent from 'ol/MapBrowserEvent';
import { Pixel } from 'ol/pixel';
import { ProjectionLike } from 'ol/proj';
import Point from 'ol/geom/Point';
// component
import BaseLayer from '@/components/layers/BaseLayer.vue';
import CategoryLayer from '@/components/layers/CategoryLayer.vue';
import Explain from '@/components/Explain.vue';
import LocationLayer from '@/components/layers/LocationLayer.vue';
import MarkerInfo from '@/components/MarkerInfo.vue';
import { MarkerProperties } from '@/interfaces/MarkerProperties';
// Helpers
import MapConfig from '@/helpers/MapConfig';
import { hexToRgb } from '@/helpers/Utility';

/**
 * Home
 */
@Component({
  name: 'Home',
  components: {
    'marker-info': MarkerInfo,
    'base-layer': BaseLayer,
    'category-layer': CategoryLayer,
    'location-layer': LocationLayer,
    explain: Explain,
  },
})
export default class Home extends Vue {
  // View
  private rotation = 0;
  private opacity = 1;
  private projection: ProjectionLike = MapConfig.projection;
  private resolutions: number[] = MapConfig.resolutions;
  private extent: Extent = MapConfig.extent;
  private hitFeature?: FeatureLike;
  // detect map move
  private isMoving = false;
  // Tooltip
  private position: Coordinate = [0, 0];
  private currentName?: string;
  private showMarkerTooltip = false;
  // Blast zone
  private coordinatesBlastZone: Coordinate = [0, 0];
  private blastZoneColorSet = colors.red;
  private blastZoneFillColor;

  /** Current zoom */
  private get zoom(): number {
    return this.$store.getters['MapLocationModule/zoom'];
  }
  private set zoom(zoom: number) {
    this.$store.dispatch('MapLocationModule/setZoom', zoom);
  }
  /** Current location */
  private get currentPosition(): Coordinate {
    return this.$store.getters['MapLocationModule/coordinate'];
  }
  private set currentPosition(coordinate: Coordinate) {
    this.$store.dispatch('MapLocationModule/setCoordinate', coordinate);
  }
  /* current category */
  private get category(): string | undefined {
    return this.$route.params.category;
  }
  /** Map class */
  private get mapClass(): string {
    return (
      'map-viewer_map' +
      (this.isMoving ? ' is_move' : '') +
      (this.currentPosition !== [0, 0] ? ' is_hover' : '')
    );
  }
  /** Map Rendering mode */
  private get renderer(): string {
    return this.$store.getters['ConfigModule/webgl'] ? 'webgl' : 'canvas';
  }

  /**
   * Before Create (for query access)
   */
  private beforeCreate(): void {
    // Load location from QueryString.
    const query = this.$route.query as { [key: string]: string };
    if (query.x && query.y) {
      this.currentPosition = [parseInt(query.x), parseInt(query.y)];
    } else {
      this.currentPosition = getCenter(MapConfig.extent);
    }
    if (query.z) {
      this.zoom = parseInt(query.z);
    }
    if (query.type) {
      this.$store.dispatch('ConfigModule/setMap', query.type);
    }
    this.blastZoneFillColor = `rgba(${hexToRgb(colors.red.accent1)},0.3)`;
  }

  /**
   * Customize Map UI.
   */
  private onMapMounted(): void {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    const map: Map = this.$refs.map.$map as unknown as Map;
    // now ol.Map instance is ready and we can work with it directly
    map.getControls().extend([
      new MousePosition({
        coordinateFormat: createStringXY(0),
      }),
      new FullScreen({
        // Set the target DOM to be displayed in full screen as the root of Vue.
        source: 'app',
      }),
      new OverviewMap({
        collapsed: true,
        collapsible: true,
      }),
      new ZoomSlider(),
    ]);
    // Disable rotate function.
    const interactions: Interaction[] = map.getInteractions().getArray();
    const pinchRotateInteraction = interactions.filter(
      (interaction: Interaction) => {
        return interaction instanceof PinchRotate;
      }
    )[0];
    pinchRotateInteraction.setActive(false);
  }
  /**
   * When move map
   */
  private onMoveStart(): void {
    this.isMoving = true;
  }
  /**
   * Whem move end map
   */
  private onMoveEnd(): void {
    this.isMoving = false;
    // Store current coordinate
  }
  /**
   * When pointer move
   */
  private onMapPointerMove(e: MapBrowserEvent): void {
    const map: Map = this.$refs.map as unknown as Map;
    // current pixel coordination
    const pixel: Pixel = e.pixel;

    this.hitFeature = map.forEachFeatureAtPixel(
      pixel,
      feature => feature
    ) as FeatureLike;

    if (!this.hitFeature) {
      // When mouse leave from any features
      this.showMarkerTooltip = false;
      return;
    }

    // クリックされたマーカーのプロパティの値を取得
    const prop: MarkerProperties =
      this.hitFeature.getProperties() as MarkerProperties;

    // ツールチップの描画位置を取得
    const point: Point = this.hitFeature.getGeometry() as Point;
    this.position = point.getFlatCoordinates();

    // ツールチップの内容を更新
    this.currentName = prop.name
      ? this.$t(`locations.${prop.name}`)
      : this.$t(`markers.${prop.type}`);
    if (prop.label) {
      this.currentName += ` (${prop.label})`;
    }

    this.showMarkerTooltip = true;
  }

  /**
   * Reset initial location. (unmounted)
   */
  public resetLocation(): void {
    const query = this.$route.query as { [key: string]: string };
    this.currentPosition = [parseInt(query.x), parseInt(query.y)];
    this.zoom = parseInt(query.zoom);
  }

  /**
   * When Interact marker
   */
  public onSelect(e: FeatureLike): void {
    // Get MarkerProperties from selected feature
    const markerInfo: MarkerInfo = this.$refs.markerInfo as MarkerInfo;
    markerInfo.open(e.getProperties() as MarkerProperties);
    // TODO: マーカーの選択を解除
  }
}
</script>

<style lang="scss">
/* stylelint-disable no-descending-specificity */
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
      > ::after,
      > ::before {
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

      > ::before {
        top: calc(50% - #{$crosshairs-width} / 2);
        left: calc(50% - #{$crosshairs-length} / 2);
        width: $crosshairs-length;
        height: $crosshairs-width;
      }

      > ::after {
        top: calc(50% - #{$crosshairs-length} / 2);
        left: calc(50% - #{$crosshairs-width} / 2);
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
        > ::after,
        > ::before {
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
  .map-viewer {
    background-color: map-get($grey, 'lighten-1');
  }

  .ol-control {
    transition: $primary-transition;
    background-color: rgba(map-get($grey, 'lighten-2'), 0.5);

    button {
      background-color: rgba(map-get($blue, 'darken-3'), 0.5);

      &:hover {
        background-color: map-get($blue, 'darken-3');
      }
    }

    &:hover {
      background-color: rgba(map-get($grey, 'lighten-2'), 0.7);
    }
  }

  .ol-overviewmap .ol-overviewmap-map {
    border-color: map-get($blue, 'darken-3');
  }
}

.theme--dark {
  .map-viewer {
    background-color: map-get($grey, 'darken-4');
  }

  .ol-control {
    transition: $primary-transition;
    background-color: rgba(map-get($grey, 'darken-3'), 0.5);

    button {
      background-color: rgba(map-get($blue, 'base'), 0.5);

      &:hover {
        background-color: map-get($blue, 'darken-3');
      }
    }

    &:hover {
      background-color: rgba(map-get($grey, 'darken-3'), 0.7);
    }
  }

  .ol-overviewmap .ol-overviewmap-map {
    border-color: map-get($blue, 'lighten-4');
  }
}
</style>
