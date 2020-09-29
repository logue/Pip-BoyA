import colors from 'vuetify/lib/util/colors';
import {Style, Circle, Text, Fill, Stroke} from 'ol/style';

// Fallout76 coordinates to pixel coordinates pixel rate.
const COORDINATES_REDUCTION_RATE = 142; // WTF?
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
      if (cur.label) {
        acc[cur.id].label = cur.label;
      }
      return acc;
    }, {})
  );
  // console.debug(converted);
  return converted;
}

/**
 * Marker data to GeoJson
 * @param {Array} markers marker location Data
 * @param {Array} center Map center location.
 * @param {Number} rate  FO76 coordinates to pixel coordinates reduction pixel rate.
 * @param {Array} offset Map offset
 * @return {Array} GeoJson Array
 */
export function convertGeoJson(
  markers,
  center,
  rate = COORDINATES_REDUCTION_RATE,
  offset = COORDINATES_OFFSET
) {
  const converted = Object.values(
    markers.reduce((acc, cur) => {
      const x = cur.x / rate + center[0] + offset[0];
      const y = cur.y / rate + center[1] + offset[1];

      acc[cur.id] = {
        type: 'Feature',
        id: cur.id,
        geometry: {
          type: 'Point',
          coordinates: [x, y],
        },
        properties: {
          id: cur.id,
          name: cur.name || undefined,
          type: cur.type,
          label: cur.label || undefined,
          x: x | 0,
          y: y | 0,
          realX: cur.x,
          realY: cur.y,
        },
      };
      return acc;
    }, {})
  );
  return converted;
}

/**
 * Generates a list of buckets describing the repartition of features.
 * @param {Feature[]} features
 * @param {string} attributeName
 * @param {number} bucketCount
 * @return {{start: number, end: number, value: number}[]}
 */
export function generateBuckets(features, attributeName, bucketCount) {
  let min = Infinity;
  let max = -Infinity;
  for (let i = 0; i < features.length; i++) {
    const attr = features[i].get(attributeName);
    if (attr > max) max = attr.valueOf();
    if (attr < min) min = attr.valueOf();
  }
  const buckets = new Array(bucketCount).fill(0).map((value, index, arr) => {
    const ratioStart = index / arr.length;
    const ratioEnd = (index + 1) / arr.length;
    return {
      start: ratioStart * (max - min) + min,
      end: ratioEnd * (max - min) + min,
      value: 0,
    };
  });

  // count features
  for (let i = 0; i < features.length; i++) {
    const attr = features[i].get(attributeName);
    for (let j = 0; j < buckets.length; j++) {
      if (attr >= buckets[j].start && attr <= buckets[j].end) {
        buckets[j].value++;
        break;
      }
    }
  }

  return buckets;
}

/**
 * Default Marker color set
 */
export const colorset = {
  tileExplainColor: [
    'cyan',
    'magenta',
    'yellow',
    'red',
    'lime',
    'blue',
    'lightgray',
    'orange',
    'springgreen',
    'pink',
    'purple',
    'darkgreen',
    'maroon',
  ],
  markerColor: [
    'red',
    'pink',
    'purple',
    'deep-purple',
    'indigo',
    'blue',
    'light-blue',
    'cyan',
    'teal',
    'green',
    'light-green',
    'lime',
    'yellow',
    'amber',
    'orange',
    'deep-orange',
    'brown',
    'blue-grey',
    'grey',
  ],
};
/**
 * Generate Marker Style
 * @return {Array}
 */
export const markerStyles = () => {
  // Material Color name (Ignore Black and White)
  // @see https://vuetifyjs.com/styles/colors/
  const styles = [];
  for (const colorName of colorset.markerColor) {
    // Get Material Color from palette color name
    const colorSet = colors[toKebabCase(colorName)];
    // Generate Color set
    styles[colorName] = new Style({
      fill: new Fill({
        color: `rgba(${hexToRgb(colorSet.accent1 || colorSet.lighten5)},0.3)`,
      }),
      stroke: new Stroke({
        color: colorSet.accent3 || colorSet.darken3,
      }),
      // Marker Config
      image: new Circle({
        // Marker size
        radius: 5,
        // Marker Border color
        stroke: new Stroke({
          // Brown and blueGrey and Grey does not have accent color
          color: colorSet.accent2 || colorSet.darken2,
        }),
        // Marker fill color
        fill: new Fill({
          color: `rgba(${hexToRgb(colorSet.accent1 || colorSet.lighten5)},0.3)`,
        }),
      }),
      // Annotation(label) text
      text: new Text({
        // Text font
        font: '"Noto Sans JP"',
        // Text color
        fill: new Fill({
          color: colorSet.darken4,
        }),
        // Text outline color and blur size.
        stroke: new Stroke({
          color: `rgba(${hexToRgb(colorSet.lighten5)}, 0.9)`,
          width: 2.5,
        }),
      }),
    });
  }
  return styles;
};

/**
 * Country icon mapping
 */
export const languages = {
  de: 'de',
  en: 'gb',
  es: 'es',
  fr: 'fr',
  it: 'it',
  ja: 'jp',
  ko: 'kr',
  pl: 'pl',
  ru: 'ru',
  'zh-cn': 'cn',
  'zh-tw': 'tw',
};

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
 * values of
 * @param {Object} obj Hashed Array
 * @return {mixed}
 */
export function valuesOf(obj) {
  return Object.keys(obj).map((key) => obj[key]);
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

  // console.debug(url);
  return process.env.IS_ELECTRON
    ? url.href.replace('/app:/./#', 'https://fo76.logue.be')
    : location.origin + url.href;
}
