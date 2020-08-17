// Offset Configure
export const COORDINATES_CENTER = [2048, -2048];
// Fallout76 coordinates to pixel coordinates pixel rate.
export const COORDINATES_REDUCTION_RATE = 144; // WTF?

/**
 * Convert Fallout76 native coordinates to map size based pixel coordinates.
 * @param {Array} markers The first number.
 * @return {Array} Converted marker location.
 */
export function convertCoordinates(markers) {
  console.debug('entries: ', markers.length);
  const converted = Object.values(
    markers.reduce((acc, cur) => {
      acc[cur.id] = {
        // Marker Id
        id: cur.id,
        // Marker Name
        name: cur.name || cur.type,
        // Marker Type
        type: cur.type,
        // Marker pixel X location
        x: (cur.x / COORDINATES_REDUCTION_RATE + COORDINATES_CENTER[0]) | 0,
        // Marker pixel Y location
        y: (cur.y / COORDINATES_REDUCTION_RATE + COORDINATES_CENTER[1]) | 0,
        // Fallout76 Native X location
        realX: cur.x,
        // Fallout76 Native Y location
        realY: cur.y,
      };
      return acc;
    }, {})
  );
  console.debug(converted);
  return converted;
}
