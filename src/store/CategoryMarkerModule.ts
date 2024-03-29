/**
 * Category Marker Module
 */
import {
  ActionContext,
  ActionTree,
  GetterTree,
  Module,
  MutationTree,
  Payload,
} from 'vuex';
import axios from 'axios';
import { Feature, Point } from 'geojson';
import { RootState } from '.';
import convertGeoJson from '@/helpers/ConvertGeoJson';
import { markerColors, tileExplainColors } from '@/helpers/MarkerStyle';
import { MarkerProperties } from '@/interfaces/MarkerProperties';
import { MarkerJsonData } from '@/interfaces/MarkerJsonData';
import { Marker } from '@/interfaces/Marker';

// Marker State
export interface CategoryMarkerState {
  // Marker location object
  features: { [key: string]: Feature<Point, MarkerProperties>[] };
  // Marker Types array
  types: { [key: string]: string[] };
  // Marker count by Type
  count: { [key: string]: number };
  // Marker color palette
  colorset: { [key: string]: string[] };
  // Overlay tile image path
  tileImage: { [key: string]: string };
}

interface DataPayload extends Payload {
  category: string;
  data: MarkerJsonData;
}

// Default value
const state: CategoryMarkerState = {
  // Marker location object
  features: {},
  // Marker Types
  types: {},
  // Marker Types counts
  count: {},
  // Marker color palette
  colorset: {},
  // Overlay tile image path
  tileImage: {},
};

// Getters
const getters: GetterTree<CategoryMarkerState, RootState> = {
  features:
    s =>
    (category: string): Feature<Point, MarkerProperties>[] =>
      s.features[category],
  types:
    s =>
    (category: string): string[] =>
      s.types[category],
  count:
    s =>
    (type: string): number =>
      s.count[type],
  colorset:
    s =>
    (category: string): string[] =>
      s.colorset[category],
  tileImage:
    s =>
    (category: string): string | undefined =>
      s.tileImage[category],
};

// Mutation
const mutations: MutationTree<CategoryMarkerState> = {
  /**
   * save features.
   * @param s Store
   * @param payload Marker GeoJson Data
   */
  async storeData(s, payload: DataPayload) {
    console.debug(`CategoryMarkerModule: Mutation: ${payload.category}`);

    const data = payload.data;
    if (payload.data.markers) {
      // convert Fo76 marker location to geo json object
      s.features[payload.category] = convertGeoJson(data.markers);

      // Get marker types.
      const itemTypes: string[] = data.markers
        .filter((item: Marker): item is Required<Marker> => Boolean(item.type))
        .map(item => item.type);

      // Array Unique
      const types: string[] = Array.from([...new Set(itemTypes)]).sort();
      s.types[payload.category] = types;

      // Reduce color palette.
      const colors: string[] = data.colorset || markerColors;
      const colorset: string[] = [];
      let colorsCount: number = colors.length;
      if (types.length > colorsCount) {
        throw new Error(
          `CategoryMarkerModule: Too many marker types. less than ${colors.length}. (${types.length} found.)`
        );
      }
      if (colors.length === markerColors.length) {
        // * Ignore Brown and Blue-gray and Gray
        colorsCount = colorsCount - 3;
      }
      for (const type of types) {
        let index: number = types.indexOf(type);

        if (colorsCount / types.length > 2) {
          // If there are not enough markers, the colors should be varied.
          index = Math.floor(index * (colorsCount / types.length));
        }
        colorset.push(colors[index]);
      }
      s.colorset[payload.category] = colorset;

      // Associative array of marker names and their numbers
      const counts: { [key: string]: number } = itemTypes.reduce(
        (acc: { [key: string]: number }, cur: string) => {
          acc[cur] = acc[cur] ? ++acc[cur] : 1;
          return acc;
        },
        {}
      );
      for (const entry in counts) {
        s.count[entry] = counts[entry];
      }
    } else {
      // タイルマーカーモード（マーカー画像が予め含まれている）
      s.colorset[payload.category] = data.colorset || tileExplainColors;
      s.types[payload.category] = data.explains || [];
    }

    s.tileImage[payload.category] = data.tileImage ? data.tileImage : '';
  },
};

// Action
const actions: ActionTree<CategoryMarkerState, RootState> = {
  /**
   * Set category location data.
   * @param context Context
   * @param category Category
   */
  async setCategory(
    context: ActionContext<CategoryMarkerState, RootState>,
    category: string
  ) {
    if (context.state.types[category] !== void 0) {
      // すでにデータが保存されていた場合は何もしない
      console.debug(
        `CategoryMarkerModule: ${category} is already loaded. skip.`
      );
      return false;
    }

    // Fetch category marker data.
    const data: MarkerJsonData = await axios
      .get(`${process.env.DATA_URI || '/data/'}${category}.json`)
      .then(
        res => res.data,
        error => context.dispatch('setError', error, { root: true })
      );
    if (!data) {
      return true;
    }
    console.debug(`commit ${category}`);
    context.commit('storeData', { category: category, data: data });
    return true;
  },
};

// VuexStore
const CategoryMarkerModule: Module<CategoryMarkerState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default CategoryMarkerModule;
