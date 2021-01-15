/**
 * Map location store
 */
import {
  ActionTree,
  ActionContext,
  GetterTree,
  Module,
  MutationTree,
} from 'vuex';
import VueRouter from 'vue-router';
import define from '@/assets/MapDefinition';
import { RootState } from '.';
import { MapTypes } from '@/types/map';
import { Coordinate } from 'ol/coordinate';
import { getCenter } from 'ol/extent';

// Map Location State
export interface MapLocationState {
  coordinate: Coordinate;
  zoom: number;
  type: MapTypes;
}

// Default value
const state: MapLocationState = {
  coordinate: getCenter(define.extent),
  zoom: 1,
  type: 1,
};

// Getters
const getters: GetterTree<MapLocationState, RootState> = {
  // Get zoom.
  zoom: (s): number => s.zoom,
  // Get uri of current location.
  uri: s => ($router: VueRouter): string => {
    // Query Parameters
    const query: { [key: string]: string } = {
      x: (s.coordinate[0] | 0).toString(),
      y: (s.coordinate[1] | 0).toString(),
      z: s.zoom.toString(),
      // t: s.type.toString(),
    };

    const uri = $router.resolve({
      query: query,
    });

    return process.env.IS_ELECTRON
      ? uri.href.replace('/app:/./#', 'https://fo76.logue.be')
      : location.origin + uri.href;
  },
  // get current coordinate
  coordinate: (s): Coordinate => s.coordinate,
};

// Mutation
const mutations: MutationTree<MapLocationState> = {
  setCoordinate(s, coordinate: Coordinate) {
    s.coordinate = coordinate;
  },
  setZoom(s, zoom: number) {
    s.zoom = zoom;
  },
  setMapType(s, type: MapTypes) {
    s.type = type;
  },
};

// Action
const actions: ActionTree<MapLocationState, RootState> = {
  /**
   * Store current Location
   * @param context Vuex Context
   * @param coordinate current coordinate
   */
  setCoordinate(
    context: ActionContext<MapLocationState, RootState>,
    coordinate: Coordinate
  ) {
    context.commit('setCoordinate', coordinate);
  },
  /**
   * Store map zoom
   * @param context Vuex Context
   * @param zoom
   */
  setZoom(context: ActionContext<MapLocationState, RootState>, zoom: number) {
    context.commit('setZoom', zoom);
  },
  /**
   * Store map type
   * @param context Vuex Context
   * @param type Map type
   */
  setMapType(
    context: ActionContext<MapLocationState, RootState>,
    type: MapTypes
  ) {
    context.commit('setMapType', type);
  },
};

// VuexStore
const MapLocation: Module<MapLocationState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default MapLocation;
