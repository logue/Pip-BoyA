/**
 * Fallout76 Pip-boy Application (Pip-BoyA／Pip坊や)
 *
 * @author    Logue <logue@hotmail.co.jp>
 * @version   0.2.0
 * @copyright 2020 Masashi Yoshikawa <https://logue.dev/> All rights reserved.
 * @license   MIT
 */

import Vue from 'vue';
import App from './App.vue';
import router from './router';

import i18n from './plugins/i18n';
import vuetify from './plugins/vuetify';
import './plugins/vuelayers';
import './plugins/axios';
import './plugins/clipboard';
import './plugins/electron';
import './plugins/cookie';
import './plugins/analytics';
import './plugins/worker';

Vue.config.productionTip = false;

new Vue({
  data() {
    // Global variables
    return {
      // map mode
      isMilitary: Boolean(this.$cookies.get('military-map')) || false,
      // map location
      location: {
        x: 2048,
        y: -2048,
        z: 1,
      },
      // display location
      displayLocation: Boolean(this.$cookies.get('display-location')) || false,
      // loading overlay
      loading: true,
    };
  },
  router,
  vuetify,
  i18n,
  render: (h) => h(App),
}).$mount('#app');
