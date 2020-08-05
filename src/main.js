/**
 * Fallout76 Pip-boya
 *
 * @author    Logue <logue@hotmail.co.jp>
 * @version   2.0.0
 * @copyright 2020 Masashi Yoshikawa <https://logue.dev/> All rights reserved.
 * @license   MIT
 */

import Vue from 'vue';
import App from './App.vue';
import router from './router';
import i18n from './plugins/i18n';
import VueAnalytics from 'vue-analytics';

import vuetify from './plugins/vuetify';
import './plugins/vuelayers';
import './plugins/axios';
import './plugins/clipboard';

Vue.config.productionTip = false;

Vue.use(VueAnalytics, {
  id: 'UA-11445748-24',
  router,
});

new Vue({
  data() {
    // Global variables
    return {
      // map mode
      isMilitary: false,
      // map location
      location: {
        x: 2048,
        y: -2048,
        z: 1,
      },
      // display location (Unmouted!)
      displayLocation: false,
      // loading overlay
      loading: true,
    };
  },
  router,
  vuetify,
  i18n,
  render: (h) => h(App),
}).$mount('#app');
