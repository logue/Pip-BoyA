/**
 * Config store
 */
import { MapTypes } from '@/interfaces/MapTypesEnum';
import {
  ActionContext,
  ActionTree,
  GetterTree,
  Module,
  MutationTree,
} from 'vuex';
import { RootState } from '.';

/** Config State */
export interface ConfigState {
  // Map Type
  mapType: MapTypes;
  // Display Location marker
  displayLocation: boolean;
  // Dark Theme mode
  themeDark: boolean;
  // WebGL Drawing mode
  webgl: boolean;
  // Expand explain box
  expandExplain: boolean;
  // Language
  locale: string;
}

/** Default state value */
const state: ConfigState = {
  mapType: 1,
  displayLocation: true,
  themeDark: window.matchMedia('(prefers-color-scheme: dark)').matches,
  webgl: false,
  expandExplain: true,
  locale:
    (window.navigator.languages && window.navigator.languages[0]) ||
    window.navigator.language,
};

// Getters
const getters: GetterTree<ConfigState, RootState> = {
  mapType: (s): MapTypes => s.mapType,
  displayLocation: (s): boolean => s.displayLocation,
  themeDark: (s): boolean => s.themeDark,
  webgl: (s): boolean => s.webgl,
  expandExplain: (s): boolean => s.expandExplain,
  locale: (s): string => s.locale,
};

// Mutation
const mutations: MutationTree<ConfigState> = {
  setMap(s, type: MapTypes) {
    s.mapType = type;
  },
  toggleMap(s) {
    s.mapType++;
    if (s.mapType >= 3) {
      s.mapType = 0;
    }
  },
  toggleLocationMarker(s) {
    s.displayLocation = !s.displayLocation;
  },
  toggleTheme(s) {
    s.themeDark = !s.themeDark;
  },
  toggleWebGl(s) {
    s.webgl = !s.webgl;
  },
  toggleExplain(s) {
    s.expandExplain = !s.expandExplain;
  },
  setLocale(s, locale: string) {
    s.locale = locale;
  },
};

// Action
const actions: ActionTree<ConfigState, RootState> = {
  /**
   * Map changer
   * @param type MapType
   * @param context Vuex Context
   */
  setMap(context: ActionContext<ConfigState, RootState>, type: MapTypes) {
    context.commit('setMap', type);
  },
  /**
   * Toggle Map type
   * @param context Vuex Context
   */
  toggleMap(context: ActionContext<ConfigState, RootState>) {
    context.commit('toggleMap');
  },
  /**
   * Show/Hide Location Marker.
   * @param context Vuex Context
   */
  toggleLocationMarker(context: ActionContext<ConfigState, RootState>) {
    context.commit('toggleLocationMarker');
  },
  /**
   * Switch Dark/Light mode.
   * @param context Vuex Context
   */
  toggleTheme(context: ActionContext<ConfigState, RootState>) {
    context.commit('toggleTheme');
  },
  /**
   * Toggle WebGL/Canvas mode
   * @param context Vuex Context
   */
  toggleWebGl(context: ActionContext<ConfigState, RootState>) {
    context.commit('toggleWebGl');
  },
  /**
   * Shrink/Expand Explain window.
   * @param context Vuex Context
   */
  toggleExplain(context: ActionContext<ConfigState, RootState>) {
    context.commit('toggleExplain');
  },
  /**
   * Change locale.
   * @param context Vuex Context
   * @param locale locale code
   */
  setLocale(context: ActionContext<ConfigState, RootState>, locale = 'en') {
    context.commit('setLocale', locale);
  },
};

// VuexStore
const ConfigModule: Module<ConfigState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default ConfigModule;
