/**
 * Config store
 */
export default {
  namespaced: true,
  state: {
    // Military Map mode
    isMilitary: false,
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
    isMilitary: (state) => state.isMilitary,
    displayLocation: (state) => state.displayLocation,
    themeDark: (state) => state.themeDark,
    webgl: (state) => state.webgl,
    expandExplain: (state) => state.expandExplain,
    locale: (state) => state.locale,
  },
  mutations: {
    toggleMap(state) {
      state.isMilitary = !state.isMilitary;
    },
    toggleLocationMarker(state) {
      state.displayLocation = !state.displayLocation;
    },
    toggleTheme(state) {
      state.themeDark = !state.themeDark;
    },
    toggleWebGl(state) {
      state.webgl = !state.webgl;
    },
    toggleExplain(state) {
      state.expandExplain = !state.expandExplain;
    },
    setLocale(state, locale) {
      state.locale = locale || 'en';
    },
  },
  actions: {
    toggleMap(context) {
      context.commit('toggleMap');
    },
    toggleLocationMarker(context) {
      context.commit('toggleLocationMarker');
    },
    toggleTheme(context) {
      context.commit('toggleTheme');
    },
    toggleWebGl(context) {
      context.commit('toggleWebGl');
    },
    toggleExplain(context) {
      context.commit('toggleExplain');
    },
    setLocale(context, locale) {
      context.commit('setLocale', locale);
    },
  },
};
