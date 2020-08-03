<template>
  <div>
    <vl-map
      :load-tiles-while-animating="true"
      :load-tiles-while-interacting="true"
      style="height: 600px;"
    >
      <vl-view
        :zoom.sync="zoom"
        :center.sync="center"
        :rotation.sync="rotation"
        :min-zoom="minZoom"
        :max-zoom="maxZoom"
        :projection="projection"
        :resolutions="resolutions"
      />

      <vl-layer-tile id="hamburg-geo">
        <vl-source-xyz
          :url="url"
          :attributions="attributions"
          :projection="projection"
          :min-zoom="minZoom"
          :max-zoom="maxZoom"
        />
      </vl-layer-tile>
    </vl-map>
    <div style="padding: 20px;">
      Zoom: {{ zoom }}
      <br />
      Center: {{ center }}
      <br />
      Rotation: {{ rotation }}
      <br />
    </div>
  </div>
</template>

<script>
import {addProjection} from 'ol/proj';
import Projection from 'ol/proj/Projection';

const mapExtent = [0.0, -2672.0, 3620.0, 0.0];
const mapMinZoom = 0;
const mapMaxZoom = 4;
const mapMaxResolution = 1.0;
const tileExtent = [0.0, -2672.0, 3620.0, 0.0];

const mapResolutions = [];
for (let z = 0; z <= mapMaxZoom; z++) {
  mapResolutions.push(Math.pow(2, mapMaxZoom - z) * mapMaxResolution);
}

const customProj = new Projection({
  code: 'custom',
  units: 'pixels',
  extent: tileExtent,
});
addProjection(customProj);

export default {
  name: 'MapOffline',
  data() {
    return {
      zoom: 1,
      center: [0, 0],
      rotation: 0,
      url: '/img/map/base/{z}/{x}/{y}.png',
      attributions:
        'hamburg-geo; Rendered with <a href="https://www.maptiler.com/desktop/">MapTiler Desktop</a>',
      extent: mapExtent,
      minZoom: mapMinZoom,
      maxZoom: mapMaxZoom,
      resolutions: mapResolutions,
      projection: customProj.getCode(),
    };
  },
};
</script>
