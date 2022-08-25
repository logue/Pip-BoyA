import type { Marker } from './Marker';

/** Marker Information */
export interface MarkerProperties extends Marker {
  /* Real X coordination */
  realX: number;
  /* Real Y coordination */
  realY: number;
}
