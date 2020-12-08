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
    features: (s) => (category) => s.features[category],
    types: (s) => (category) => s.types[category],
    items: (s) => (category) => s.items[category],
    colorset: (s) => (category) => s.colorset[category],
    tileImage: (s) => (category) => s.tileImage[category],
    style: (s) => (type) => s.styles[type],
  },
  mutations: {
    /**
     * save to state category location data.
     * @param {Vuex.Store} s Store
     * @param {object} payload data
     */
    set(s, payload) {
      s.colorset[payload.category] = payload.colorset;

      if (payload.types) {
        s.types[payload.category] = payload.types;
      }
      s.items[payload.category] = payload.items;
      s.tileImage[payload.category] = payload.tileImage;
    },
    /**
     * save features.
     * @param {Vuex.Store} s Store
     * @param {object} payload Marker data
     */
    setFeatures(s, payload) {
      s.features[payload.category] = convertGeoJson(payload.features);
    },
    /**
     * save to marker style set.
     * @param {Vuex.Store} s Store
     */
    setStyle(s) {
      s.styles = markerStyles();
    },
  },
  actions: {
    /**
     * Init style set
     * @param {Vuex.ActionContext} context Context
     */
    init(context) {
      context.commit('setStyle');
    },
    /**
     * Set category location data.
     * @param {Vuex.ActionContext} context Context
     * @param {String} category Category
     */
    async getCategory(context, category) {
      // Fetch category marker data.
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

        console.debug(types);

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
