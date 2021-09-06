import { Marker } from './Marker';

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
