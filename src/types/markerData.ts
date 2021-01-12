// Data Format
export interface MarkerJsonData {
  // Overlay tile image path (for Nuclear Winter and tile based marker)
  tileImage?: string;
  // Explain text override (For tile based marker)
  explains?: string[];
  // Marker colorset override
  colorset?: string[];
  // Marker Data
  markers: Marker[];
}

export interface Marker {
  // Location ID
  id: string;
  // Location key name
  name?: string;
  // Marker Type
  type?: string;
  // Marker Label
  label?: string;
  // sub information
  sub?: string;
  // X coordination
  x: number;
  // Y coordination
  y: number;
}

// MarkerData
export interface MarkerProperties extends Marker {
  // Real X coordination
  realX: number;
  // Real Y coordination
  realY: number;
}
