import Vue from 'vue';
import Vuex from 'vuex';
import VuexPersistence from 'vuex-persist';

import config from './config';
import location from './location';
import locationMarker from './locationMarker';
import marker from './marker';

Vue.use(Vuex);

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state: {
    // ローディングオーバーレイの表示制御
    loading: true,
    // 進捗
    progress: null,
    // スナックバーのメッセージ
    message: null,
  },
  getters: {
    loading: (state) => state.loading,
    progress: (state) => state.progress,
    message: (state) => state.message,
  },
  mutations: {
    setLoading(state, display) {
      state.loading = display;
    },
    setProgress(state, progress) {
      state.progress = progress;
      state.loading = true;
    },
    setMessage(state, message) {
      state.message = message;
    },
  },
  actions: {
    setLoading(context, display = false) {
      context.commit('setLoading', display);
    },
    setProgress(context, progress = null) {
      context.commit('setProgress', progress);
    },
    setMessage(context, message = null) {
      context.commit('setMessage', message);
    },
  },
  modules: {
    config: config,
    location: location,
    marker: marker,
    locationMarker: locationMarker,
  },
  plugins: [
    // ブラウザを閉じても保存されるデータ
    new VuexPersistence({
      key: 'pipBoyA',
      storage: window.localStorage,
      modules: ['marker', 'config'],
    }).plugin,
    // ブラウザを閉じるまで保存されるデータ
    new VuexPersistence({
      key: 'pipBoyA',
      storage: window.sessionStorage,
      modules: ['location'],
    }).plugin,
  ],
});
