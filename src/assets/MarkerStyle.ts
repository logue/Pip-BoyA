import colors from 'vuetify/lib/util/colors';
import { Style, Circle, Text, Fill, Stroke, Icon } from 'ol/style';
import IconAnchorUnits from 'ol/style/IconAnchorUnits';
import { toCamelCase, hexToRgb } from './Utility';

// tile mode colorset
export const tileExplainColors: string[] = [
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
];

// marker mode colorset
export const markerColors: string[] = [
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
];

/**
 * Generate Marker Style set
 */
export function getMarkerStyles(): { [key: string]: Style } {
  // Material Color name (Ignore Black and White)
  // @see https://vuetifyjs.com/styles/colors/
  const styles: { [key: string]: Style } = {};
  for (const colorName of markerColors) {
    // Generate Color set
    styles[colorName] = getMarkerStyle(colorName);
  }
  return Object.freeze(styles);
}

// Cache Marker Color Style
const colorStyleCache: { [key: string]: Style } = {};
/**
 * Get Marker Style by color
 * @param color Material Color
 */
export function getMarkerStyle(color: string): Style {
  let c = toCamelCase(color);
  if (!c) c = color = 'blue';
  const colorSet = colors[c];
  if (colorStyleCache[color]) {
    return colorStyleCache[color];
  }
  colorStyleCache[color] = new Style({
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
      text: '',
    }),
  });
  return colorStyleCache[color];
}

// Cache Icon Marker Style
const iconStyleCache: { [key: string]: Style } = {};
/**
 * Get Icon Marker Style by Marker Type.
 * @param type Marker Type
 */
export function getMarkerIconStyle(type: string): Style {
  if (iconStyleCache[type]) {
    return iconStyleCache[type];
  }
  iconStyleCache[type] = new Style({
    // Icon
    image: new Icon({
      anchor: [0.5, type === 'WaypointMarker' ? 0.9 : 0.5],
      anchorXUnits: IconAnchorUnits.FRACTION,
      anchorYUnits: IconAnchorUnits.FRACTION,
      crossOrigin: 'anonymous',
      opacity: 1,
      src: `/img/marker/${type}.svg`,
    }),
    // Lebel text
    text: new Text({
      font: 'Noto Sans JP',
      offsetX: 2,
      offsetY: 2,
      // Text color
      fill: new Fill({
        color: colors.blueGrey.darken4,
      }),
      // Text outline
      stroke: new Stroke({
        color: colors.blueGrey.lighten5,
        width: 1,
      }),
      text: '',
    }),
  });
  return iconStyleCache[type];
}
