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
import { RootState } from '.';
import { getUri } from '@/assets/Utility';
import { CurrentMapLocation } from '@/types/map';

// Map Location State
export interface MapLocationState {
  x: number;
  y: number;
  z: number;
}

// Default value
const state: MapLocationState = {
  x: 2048,
  y: -2048,
  z: 0,
};

// Getters
const getters: GetterTree<MapLocationState, RootState> = {
  // Get zoom.
  zoom: (s): number => s.z,
  // Get uri of current location.
  uri: s => (router: VueRouter): string => getUri(s, router),
};

// Mutation
const mutations: MutationTree<MapLocationState> = {
  set(s, payload) {
    s.x = Math.floor(payload.x);
    s.y = Math.floor(payload.y);
    s.z = Math.floor(payload.z);
  },
};

// Action
const actions: ActionTree<MapLocationState, RootState> = {
  /**
   * Store current Location
   * @param context Vuex Context
   * @param location current location
   */
  set(
    context: ActionContext<MapLocationState, RootState>,
    location: CurrentMapLocation = { x: 0, y: 0, z: 0 }
  ) {
    context.commit('set', location);
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
