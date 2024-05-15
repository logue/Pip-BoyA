/**
 * Map Configure
 *
 * ref: https://jsfiddle.net/kay99yor/
 */
import { addProjection } from 'ol/proj';
import type { Extent } from 'ol/extent';
import Projection from 'ol/proj/Projection';
import TileGrid from 'ol/tilegrid/TileGrid';
import type { MapDefinition } from '@/interfaces/MapDefinition';
import Units from 'ol/proj/Units';

// The value output by MapTiler is used as is.
const mapExtent: Extent = [0.0, -4096.0, 4096.0, 0.0];
const mapMinZoom = 0;
const mapMaxZoom = 4;
const mapMaxResolution = 16;
const tileExtent: Extent = [0.0, -4096.0, 4096.0, 0.0];
const mapResolutions = [32, 16, 8, 4, 2, 1];

const mapTileGrid: TileGrid = new TileGrid({
  extent: tileExtent,
  minZoom: mapMinZoom,
  resolutions: mapResolutions,
});

const customProj: Projection = new Projection({
  code: 'raster',
  units: Units.TILE_PIXELS,
  extent: mapExtent,
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
