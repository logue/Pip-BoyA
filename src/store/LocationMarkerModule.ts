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
import { Style } from 'ol/style';
import convertGeoJson from '@/assets/ConvertGeoJson';
import { Marker, MarkerProperties, MarkerJsonData } from '@/types/markerData';
import { RootState } from '.';
import { getMarkerIconStyle } from '@/assets/MarkerStyle';

export interface LocationMarkerState {
  // Marker location object
  features: Feature<Point, MarkerProperties>[];
  // Marker Style definition.
  styles: { [key: string]: Style };
}

// Defaults
const state: LocationMarkerState = {
  features: [],
  styles: {},
};

// Getters
const getters: GetterTree<LocationMarkerState, RootState> = {
  // Get Features
  features: (s): Feature<Point, MarkerProperties>[] => s.features,
  // Get Marker style by type
  style: s => (type: string): Style => s.styles[type],
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
  /**
   * save style to state.
   * @param s Vuex State
   * @param types data
   */
  setStyles(s, types: string[]) {
    const styles: { [key: string]: Style } = {};
    // スタイル定義をキャッシュする
    for (const type of types) {
      styles[type] = getMarkerIconStyle(type);
    }
    s.styles = Object.freeze(styles);
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
      .get('/data/locations.json')
      .then(ret => ret.data)
      .catch(err => console.error(err));

    // Get marker types.
    const types: string[] = [
      ...new Set(
        data.markers
          .filter((item: Marker): item is Required<Marker> =>
            Boolean(item.type)
          )
          .map(item => item.type)
      ),
    ].sort();

    // Store Marker styles.
    context.commit('setStyles', types);

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
