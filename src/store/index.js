import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import config from './config';
import location from './location';

Vue.use(Vuex);

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state: {},
  mutations: {},
  actions: {},
  modules: {
    config: config,
    location: location,
  },
  plugins: [
    createPersistedState({
      key: 'pipBoyA',
      storage: window.sessionStorage,
    }),
  ],
});
