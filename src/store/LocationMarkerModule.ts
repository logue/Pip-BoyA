/**
 * Location Marker Module
 */
import {
  ActionTree,
  ActionContext,
  GetterTree,
  MutationTree,
  Module,
} from 'vuex';
import axios from 'axios';
import { Feature, Point } from 'geojson';
import convertGeoJson from '@/helpers/ConvertGeoJson';
import { RootState } from '.';
import { MarkerProperties } from '@/interfaces/MarkerProperties';
import { Marker } from '@/interfaces/Marker';
import { MarkerJsonData } from '@/interfaces/MarkerJsonData';

export interface LocationMarkerState {
  // Marker location object
  features: Feature<Point, MarkerProperties>[];
}

// Defaults
const state: LocationMarkerState = {
  features: [],
};

// Getters
const getters: GetterTree<LocationMarkerState, RootState> = {
  // Get Features
  features: (s): Feature<Point, MarkerProperties>[] => s.features,
};

// Mutation
const mutations: MutationTree<LocationMarkerState> = {
  /**
   * save location data to state.
   * @param s Vuex State
   * @param markers data
   */
  setFeatures(s, markers: Marker[]) {
    s.features = convertGeoJson(markers);
  },
};

// Action
const actions: ActionTree<LocationMarkerState, RootState> = {
  /**
   * Set location data.
   * @param context Context
   */
  async init(context: ActionContext<LocationMarkerState, RootState>) {
    if (context.state.features.length !== 0) {
      return;
    }
    const data: MarkerJsonData = await axios
      .get(`${process.env.DATA_URI || '/data/'}locations.json`)
      .then((ret: { data: MarkerJsonData }) => ret.data)
      .catch((error: unknown) =>
        context.dispatch('setError', error, { root: true })
      );

    // Store Marker locations.
    context.commit('setFeatures', data.markers);
  },
};

// VuexStore
const LocationMarkerModule: Module<LocationMarkerState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default LocationMarkerModule;
