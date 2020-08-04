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

import vuetify from './plugins/vuetify';
import './plugins/vuelayers';
import './plugins/axios';
import './plugins/clipboard';

Vue.config.productionTip = false;

new Vue({
  data() {
    return {
      isMilitary: false,
      location: {
        x: 2048,
        y: -2048,
        z: 1,
      },
      loading: true,
    };
  },
  router,
  vuetify,
  i18n,
  render: (h) => h(App),
}).$mount('#app');
