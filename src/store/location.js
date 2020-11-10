import {getUri} from '@/assets/utility.js';
/**
 * Map location store
 */
export default {
  namespaced: true,
  state: {
    x: 2048,
    y: -2048,
    z: 1,
  },
  getters: {
    zoom: (state) => state.z | 0,
    uri: (state) => (router) => getUri(state, router),
  },
  mutations: {
    set(state, {x, y, z}) {
      state.x = x;
      state.y = y;
      state.z = z;
    },
  },
  actions: {
    set(context, location = {x: 0, y: 0, z: 0}) {
      context.commit('set', location);
    },
  },
};
