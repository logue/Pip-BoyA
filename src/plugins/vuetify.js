import Vue from 'vue';
import Vuetify from 'vuetify/lib';

import '@mdi/font/scss/materialdesignicons.scss';
Vue.use(Vuetify);

export default new Vuetify({
  theme: {
    dark: window.matchMedia('(prefers-color-scheme: dark)').matches,
  },
});
