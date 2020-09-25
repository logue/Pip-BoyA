/**
 * Fallout76 Pip-boy Application (Pip-BoyA／Pip坊や)
 *
 * @author    Logue <logue@hotmail.co.jp>
 * @version   0.3.0
 * @copyright 2020 Masashi Yoshikawa <https://logue.dev/> All rights reserved.
 * @license   MIT
 */

import Vue from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';

import i18n from './plugins/i18n';
import vuetify from './plugins/vuetify';
import './plugins/vuelayers';
import './plugins/axios';
import './plugins/clipboard';
import './plugins/electron';
import './plugins/cookie';
import './plugins/analytics';
// import './plugins/worker';

Vue.config.productionTip = false;

new Vue({
  data() {
    const title = this.$t('title');
    // Global variables
    return {
      // App title
      title: process.env.IS_ELECTRON
        ? title.replace(/Web/g, 'Electron')
        : title,
      // loading overlay
      loading: true,
    };
  },

  router,
  vuetify,
  i18n,
  store,
  render: (h) => h(App),
}).$mount('#app');
