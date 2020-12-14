/**
 * Config store
 */
export default {
  namespaced: true,
  state: {
    // Military Map mode
    map: 0,
    // Display Location marker
    displayLocation: true,
    // Dark Theme mode
    themeDark: window.matchMedia('(prefers-color-scheme: dark)').matches,
    // WebGL Drawing mode
    webgl: false,
    // Expand explain box
    expandExplain: true,
    // Language
    locale:
      (window.navigator.languages && window.navigator.languages[0]) ||
      window.navigator.language ||
      window.navigator.userLanguage ||
      window.navigator.browserLanguage,
  },
  getters: {
    isMilitary: (s) => s.isMilitary,
    displayLocation: (s) => s.displayLocation,
    themeDark: (s) => s.themeDark,
    webgl: (s) => s.webgl,
    expandExplain: (s) => s.expandExplain,
    locale: (s) => s.locale,
  },
  mutations: {
    toggleMap(s) {
      s.map++;
      if (s.map >= 3) {
        s.map = 0;
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
    setLocale(s, locale) {
      s.locale = locale || 'en';
    },
  },
  actions: {
    /**
     * Map switcher
     * @param {Vuex.ActionContext} context Vuex Context
     */
    toggleMap(context) {
      context.commit('toggleMap');
    },
    /**
     * Show/Hide Location Marker.
     * @param {Vuex.ActionContext} context Vuex Context
     */
    toggleLocationMarker(context) {
      context.commit('toggleLocationMarker');
    },
    /**
     * Switch Dark/Light mode.
     * @param {Vuex.ActionContext} context Vuex Context
     */
    toggleTheme(context) {
      context.commit('toggleTheme');
    },
    /**
     * Toggle WebGL/Canvas mode
     * @param {Vuex.ActionContext} context Vuex Context
     */
    toggleWebGl(context) {
      context.commit('toggleWebGl');
    },
    /**
     * Shrink/Expand Explain window.
     * @param {Vuex.ActionContext} context Vuex Context
     */
    toggleExplain(context) {
      context.commit('toggleExplain');
    },
    /**
     * Change locale.
     * @param {Vuex.ActionContext} context Vuex Context
     * @param {string} locale locale code
     */
    setLocale(context, locale) {
      context.commit('setLocale', locale);
    },
  },
};
