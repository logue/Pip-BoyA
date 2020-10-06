import axios from 'axios';
import {convertGeoJson, colorset, markerStyles} from '@/assets/utility.js';

/**
 * Map location store
 */
export default {
  namespaced: true,
  state: {
    features: {},
    styles: markerStyles(),
    types: {},
    colorset: {},
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
      console.log(state);
    },
  },
  actions: {
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
        payload.features = convertGeoJson(data.markers);
        payload.colorset = data.colorset || colorset.markerColor;
        // タイプ一覧を生成
        const types = Array.from(new Set(data.markers));

        // マーカー名とその個数の連想配列を生成し、typesに代入
        // {タイプ名: マーカーの個数}
        payload.types = types
          .map((item) => item.type)
          .sort()
          .reduce((prev, cur) => {
            prev[cur] = (prev[cur] || 0) + 1;
            return prev;
          }, {});

        if (payload.types.length > payload.colorset.length) {
          throw new Error(
            `Too many marker types. less than ${payload.colorset.length}`
          );
        }
      } else {
        payload.features = [];
        payload.colorset = data.colorset || colorset.tileExplainColor;
        payload.types = {...data.explains};
      }
      payload.tileImage = data.tileImage || null;
      context.commit('set', payload);
    },
  },
};
