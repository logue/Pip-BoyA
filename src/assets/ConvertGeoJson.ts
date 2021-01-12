import config from './MapDefinition';
import { Marker, MarkerProperties } from '@/types/markerData';
import { Feature, Point } from 'geojson';
import { getCenter } from 'ol/extent';
import { Coordinate } from 'ol/coordinate';

// Fallout76 coordinates to pixel coordinates pixel rate.
const COORDINATES_REDUCTION_RATE = 142; // WTF?
const COORDINATES_OFFSET: Coordinate = [0, -0];

/**
 * Marker data to GeoJson
 * @param markers marker location Data
 * @return GeoJson Array
 */
export default (markers: Marker[]): Feature<Point, MarkerProperties>[] => {
  const center: Coordinate = getCenter(config.extent);
  // Create a GeoJson array with ID as a key to remove duplicate IDs.
  const converted: {
    [key: string]: Feature<Point, MarkerProperties>;
  } = markers.reduce(
    (acc: { [key: string]: Feature<Point, MarkerProperties> }, cur: Marker) => {
      // Fallout coordinates to pixel coordinates
      const coordinates: Coordinate = [
        cur.x / COORDINATES_REDUCTION_RATE + center[0] + COORDINATES_OFFSET[0],
        cur.y / COORDINATES_REDUCTION_RATE + center[1] + COORDINATES_OFFSET[1],
      ];

      // Insert entries.
      acc[cur.id] = {
        type: 'Feature',
        id: cur.id,
        geometry: {
          type: 'Point',
          coordinates: coordinates,
        },
        properties: {
          id: cur.id,
          name: cur.name || undefined,
          sub: cur.sub || undefined,
          type: cur.type,
          label: cur.label || undefined,
          x: coordinates[0],
          y: coordinates[1],
          realX: cur.x,
          realY: cur.y,
        },
      };
      return acc;
    },
    {}
  );
  // Remove key.
  return Object.values(converted);
};
