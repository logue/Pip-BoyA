import Vue from 'vue';
import Vuex, {
  ActionContext,
  ActionTree,
  GetterTree,
  MutationTree,
  StoreOptions,
} from 'vuex';
import VuexPersistence from 'vuex-persist';

import ConfigModule from './ConfigModule';
import MapLocationModule from './MapLocationModule';
import LocationMarkerModule from './LocationMarkerModule';
import CategoryMarkerModule from './CategoryMarkerModule';

Vue.use(Vuex);

export interface RootState {
  // Loading overlay
  loading: boolean;
  // ProgressBar Percentage
  progress: number;
  // SnackBar Text
  message?: string;
}

// State
const state: RootState = {
  loading: false,
  progress: 0,
  message: null,
};

// Getters
const getters: GetterTree<RootState, RootState> = {
  loading: (s): boolean => s.loading,
  progress: (s): number => s.progress,
  message: (s): string | null => s.message,
};

// Mutation
const mutations: MutationTree<RootState> = {
  setLoading(s, display: boolean) {
    s.loading = display;
  },
  setProgress(s, progress: number) {
    s.progress = progress;
    s.loading = true;
  },
  setMessage(s, message?: string) {
    s.message = message;
  },
};

// Action
const actions: ActionTree<RootState, RootState> = {
  setLoading(context: ActionContext<RootState, RootState>, display = false) {
    context.commit('setLoading', display);
  },
  setProgress(context: ActionContext<RootState, RootState>, progress = 0) {
    context.commit('setProgress', progress);
  },
  setMessage(context: ActionContext<RootState, RootState>, message = null) {
    context.commit('setMessage', message);
  },
};

// VuexStore
const store: StoreOptions<RootState> = {
  strict: process.env.NODE_ENV !== 'production',
  state,
  getters,
  mutations,
  actions,
  modules: {
    ConfigModule,
    LocationMarkerModule,
    MapLocationModule,
    CategoryMarkerModule,
  },
  plugins: [
    // ブラウザを閉じても保存されるデータ
    new VuexPersistence({
      key: 'pipBoyA',
      storage: window.localStorage,
      modules: ['ConfigModule', 'LocationMarkerModule', 'CategoryMarkerModule'],
    }).plugin,
    // ブラウザを閉じるまで保存されるデータ
    new VuexPersistence({
      key: 'pipBoyA',
      storage: window.sessionStorage,
      modules: ['MapLocationModule'],
    }).plugin,
  ],
};

export default new Vuex.Store<RootState>(store);
