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
    zoom: (s) => s.z | 0,
    uri: (s) => (router) => getUri(s, router),
  },
  mutations: {
    set(s, {x, y, z}) {
      s.x = x;
      s.y = y;
      s.z = z;
    },
  },
  actions: {
    /**
     *
     * @param {Vuex.ActionContext} context Vuex Context
     * @param {object} location current location
     */
    set(context, location = {x: 0, y: 0, z: 0}) {
      context.commit('set', location);
    },
  },
};
