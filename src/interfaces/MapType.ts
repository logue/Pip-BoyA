const MapTypes = {
  MILITARY: 'military',
  BASE: 'base',
  REALISTIC: 'realistic',
} as const;

export type MapType = typeof MapTypes[keyof typeof MapTypes];

export default MapTypes;
