/**
 * Map Configure
 *
 * ref: https://jsfiddle.net/kay99yor/
 */
import {addProjection} from 'ol/proj';
import {getCenter} from 'ol/extent';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';

// The value output by MapTiler is used as is.
/***************************************************/
const mapExtent = [0.0, -4096.0, 4096.0, 0.0];
const mapMinZoom = 1;
const mapMaxZoom = 5;
const mapMaxResolution = 0.5;
const tileExtent = [0.0, -4096.0, 4096.0, 0.0];
/***************************************************/

const mapResolutions = [];
for (let z = mapMinZoom; z <= mapMaxZoom; z++) {
  mapResolutions.push(Math.pow(2, mapMaxZoom - z) * mapMaxResolution);
}

// eslint-disable-next-line new-cap
const mapTileGrid = new TileGrid({
  extent: tileExtent,
  minZoom: mapMinZoom,
  resolutions: mapResolutions,
});

const customProj = new Projection({
  code: 'ZOOMIFY',
  units: 'pixels',
  extent: tileExtent,
});
addProjection(customProj);

const config = {
  center: getCenter(mapExtent),
  extent: mapExtent,
  minZoom: mapMinZoom,
  maxZoom: mapMaxZoom,
  resolutions: mapTileGrid.getResolutions(),
  projection: customProj.getCode(),
  tileGrid: mapTileGrid,
  tilePixelRatio: 1.0,
};

export default config;
