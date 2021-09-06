/** Marker Entry */
export interface Marker {
  /** Location ID */
  id: string;
  /** Location key name */
  name?: string;
  /** Marker Type */
  type?: string;
  /** Marker Label */
  label?: string;
  /** sub information */
  sub?: string;
  /** Marker icon */
  icon?: string;
  /** X coordination */
  x: number;
  /** Y coordination */
  y: number;
}
