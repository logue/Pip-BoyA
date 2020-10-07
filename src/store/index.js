import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import config from './config';
import location from './location';
import marker from './marker';

Vue.use(Vuex);

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state: {
    // ローディングオーバーレイの表示制御
    loading: true,
    // スナックバーのテキスト
    message: null,
  },
  getters: {
    loading: (state) => state.loading,
    message: (state) => state.message,
  },
  mutations: {
    setLoading(state, display) {
      state.loading = display;
    },
    setMessage(state, message) {
      state.message = message || '';
    },
  },
  actions: {
    setLoading(context, display = false) {
      context.commit('setLoading', display);
    },
    setMessage(context, message = null) {
      context.commit('setMessage', message);
    },
  },
  modules: {
    config: config,
    location: location,
    marker: marker,
  },
  plugins: [
    createPersistedState({
      key: 'pipBoyA',
      storage: window.localStorage,
      paths: ['marker', 'config'],
    }),
    createPersistedState({
      key: 'pipBoyA',
      storage: window.sessionStorage,
      paths: ['location'],
    }),
  ],
});
