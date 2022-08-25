import type { Extent } from 'ol/extent';
import type TileGrid from 'ol/tilegrid/TileGrid';

/** Map Configure Structure */
export interface MapDefinition {
  extent: Extent;
  minZoom: number;
  maxZoom: number;
  resolutions: number[];
  mapMaxResolution: number;
  projection: string;
  tileGrid: TileGrid;
  tilePixelRatio: number;
}
