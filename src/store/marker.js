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
    styles: [],
    // Marker Type and counts
    types: {},
    // Marker Types array
    items: {},
    // Marker color palette
    colorset: {},
    // Overlay tile image path
    tileImage: {},
  },
  getters: {
    features: (state) => (category) => state.features[category],
    types: (state) => (category) => state.types[category],
    items: (state) => (category) => state.items[category],
    colorset: (state) => (category) => state.colorset[category],
    tileImage: (state) => (category) => state.tileImage[category],
    style: (state) => (type) => state.styles[type],
  },
  mutations: {
    /**
     * save to state category location data.
     * @param {Vuex.State} state Vuex State
     * @param {object} payload data
     */
    set(state, payload) {
      state.colorset[payload.category] = payload.colorset;

      if (payload.types) {
        state.types[payload.category] = payload.types;
      }
      state.items[payload.category] = payload.items;
      state.tileImage[payload.category] = payload.tileImage;
    },
    setFeatures(state, payload) {
      state.features[payload.category] = convertGeoJson(payload.features);
    },
    /**
     * save to marker style set.
     * @param {Vuex.State} state Vuex State
     */
    setStyle(state) {
      state.styles = markerStyles();
      console.log('setStyle');
    },
  },
  actions: {
    /**
     * Init style set
     * @param {Vuex.State} context Context
     */
    init(context) {
      context.commit('setStyle');
    },
    /**
     * Set category location data.
     * @param {Vuex.State} context Context
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
        context.commit('setFeatures', {
          category: category,
          features: data.markers,
        });
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
        payload.items = Object.keys(payload.types);
      } else {
        // タイルマーカーモード（マーカー画像が予め含まれている）
        payload.colorset = data.colorset || colorset.tileExplainColor;
        payload.items = data.explains;
      }
      payload.tileImage = data.tileImage || null;
      context.commit('set', payload);
    },
  },
};
