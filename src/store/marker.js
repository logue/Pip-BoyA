import axios from 'axios';
import {convertGeoJson, colorset, markerStyles} from '@/assets/utility.js';

/**
 * Map Marker location store
 */
export default {
  namespaced: true,
  state: {
    // Marker location object
    features: {},
    // Marker Style definition.
    styles: {},
    // Marker Types
    types: {},
    // Marker color palette
    colorset: {},
    // Overlay tile image path
    tileImage: {},
  },
  getters: {
    features: (state) => (category) => state.features[category],
    types: (state) => (category) => state.types[category],
    colorset: (state) => (category) => state.colorset[category],
    tileImage: (state) => (category) => state.tileImage[category],
  },
  mutations: {
    /**
     * save to state category location data.
     * @param {VueAxios.State} state Vuex State
     * @param {object} payload data
     */
    set(state, payload) {
      state.features[payload.category] = payload.features;
      state.colorset[payload.category] = payload.colorset;
      state.types[payload.category] = payload.types;
      state.tileImage[payload.category] = payload.tileImage;
    },
    /**
     * save to marker style set.
     * @param {VueAxios.State} state Vuex State
     * @param {object} payload data
     */
    setStyle(state, payload) {
      state.styles = payload;
    },
  },
  actions: {
    /**
     * Init style set
     * @param {VueAxios.State} context Context
     */
    init(context) {
      context.commit('setStyle', markerStyles());
    },
    /**
     * Set category location data.
     * @param {VueAxios.State} context Context
     * @param {String} category Category
     */
    async getCategory(context, category) {
      const data = await axios.get(`/data/${category}.json`).then(
        (res) => res.data,
        () => ''
      );
      const payload = {};
      payload.category = category;
      if (data.markers) {
        // convert Fo76 marker location to geo json object
        payload.features = convertGeoJson(data.markers);
        payload.colorset = [];

        const colors = data.colorset || colorset.markerColor;
        // Get marker types.
        const types = Array.from(
          new Set(data.markers.map((item) => item.type))
        ).sort();

        if (types.length > colors.length) {
          throw new Error(`Too many marker types. less than ${colors.length}`);
        }

        // Reduce color palette.
        for (const type of types) {
          let index = types.indexOf(type);

          if ((colors.length - 3) / types.length > 2) {
            // If there are not enough markers, the colors should be varied.
            // * Ignore Brown and Blue-gray and Gray
            index = (index * ((colors.length - 3) / types.length)) | 0;
          }
          payload.colorset.push(colors[index]);
        }

        // マーカー名とその個数の連想配列を生成し、payload.typesに代入
        // {タイプ名: マーカーの個数}
        payload.types = Array.from(new Set(data.markers))
          .map((item) => item.type)
          .sort()
          .reduce((prev, cur) => {
            prev[cur] = (prev[cur] || 0) + 1;
            return prev;
          }, {});
      } else {
        // タイルマーカーモード（マーカー画像が予め含まれている）
        payload.features = [];
        payload.colorset = data.colorset || colorset.tileExplainColor;
        payload.types = {...data.explains};
      }
      payload.tileImage = data.tileImage || null;
      context.commit('set', payload);
    },
  },
};
