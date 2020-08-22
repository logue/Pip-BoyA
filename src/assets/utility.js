// Fallout76 coordinates to pixel coordinates pixel rate.
const COORDINATES_REDUCTION_RATE = 141; // WTF?
const COORDINATES_OFFSET = [0, -0];
/**
 * Convert Fallout76 native coordinates to map size based pixel coordinates.
 *
 * @param {Array} markers marker location Data
 * @param {Array} center Map center location.
 * @param {Number} rate  FO76 coordinates to pixel coordinates reduction pixel rate.
 * @param {Array} offset Map offset
 * @return {Array} Converted marker location.
 */
export function convertCoordinates(
  markers,
  center,
  rate = COORDINATES_REDUCTION_RATE,
  offset = COORDINATES_OFFSET
) {
  const converted = Object.values(
    markers.reduce((acc, cur) => {
      acc[cur.id] = {
        // Marker Id
        id: cur.id,
        // Marker Name
        name: cur.name,
        // Marker Type
        type: cur.type,
        // Marker pixel X location
        x: ((cur.x | 0) / rate + center[0] + offset[0]) | 0,
        // Marker pixel Y location
        y: ((cur.y | 0) / rate + center[1] + offset[1]) | 0,
        // Fallout76 Native X location
        realX: cur.x,
        // Fallout76 Native Y location
        realY: cur.y,
      };
      if (cur.annotation) {
        acc[cur.id].annotation = cur.annotation;
      }
      return acc;
    }, {})
  );
  // console.debug(converted);
  return converted;
}

/**
 * Convert hex color code to rgb array.
 *
 * @param {String} hex HEX Color code (#FFFFFF)
 * @return {Array} rgb array [255, 255, 255]
 */
export function hexToRgb(hex) {
  return hex
    .replace(
      /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
      (m, r, g, b) => '#' + r + r + g + g + b + b
    )
    .substring(1)
    .match(/.{2}/g)
    .map((x) => parseInt(x, 16));
}

/**
 * camel-case to kebabCase
 *
 * @param {String} s camel-case string
 * @return {String} kebabCase String
 */
export function toKebabCase(s) {
  return s.replace(/-./g, (x) => x.toUpperCase()[1]);
}

/**
 * Get location uri.
 *
 * @param {Array} loc Current location
 * @param {Object} $router Vue Router Object
 * @return {String}
 */
export function getUri(loc, $router) {
  // URLを更新
  const url = $router.resolve({
    query: {x: loc.x, y: loc.y, z: loc.z},
  });
  return 'https://fo76.logue.be' + url.href.replace('#', '');
}
