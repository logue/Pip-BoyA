/**
 * Map Configure
 *
 * ref: https://jsfiddle.net/kay99yor/
 */
import { addProjection } from 'ol/proj';
import { Extent } from 'ol/extent';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';
import { MapDefinition } from '@/interfaces/MapDefinition';

// The value output by MapTiler is used as is.
const mapExtent: Extent = [0.0, -4096.0, 4096.0, 0.0];
const mapMinZoom = 1;
const mapMaxZoom = 5;
const mapMaxResolution = 0.5;
const tileExtent: Extent = [0.0, -4096.0, 4096.0, 0.0];

// Do not change below lines.
const mapResolutions: number[] = [];
for (let z = mapMinZoom; z <= mapMaxZoom; z++) {
  mapResolutions.push(Math.pow(2, mapMaxZoom - z) * mapMaxResolution);
}

const mapTileGrid: TileGrid = new TileGrid({
  extent: tileExtent,
  minZoom: mapMinZoom,
  resolutions: mapResolutions,
});

const customProj: Projection = new Projection({
  code: 'ZOOMIFY',
  units: 'pixels',
  extent: tileExtent,
});
addProjection(customProj);

const config: MapDefinition = {
  extent: mapExtent,
  minZoom: mapMinZoom,
  maxZoom: mapMaxZoom,
  resolutions: mapTileGrid.getResolutions(),
  mapMaxResolution: mapMaxResolution,
  projection: customProj.getCode(),
  tileGrid: mapTileGrid,
  tilePixelRatio: 1.0,
};

export default config;
