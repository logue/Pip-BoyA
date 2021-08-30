/**
 * Fallout76 Pip-boy Application (Pip-BoyA／Pip坊や)
 *
 * @author    Logue <logue@hotmail.co.jp>
 * @version   0.6.3-beta
 * @copyright 2020-2021 Masashi Yoshikawa <https://logue.dev/> All rights reserved.
 * @license   MIT
 */

import Vue from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';

import './plugins/analytics';
import './plugins/forceNextTick';
import './plugins/vuelayers';
import './plugins/vue-electron';
import i18n from './plugins/i18n';
import vuetify from './plugins/vuetify';

Vue.config.productionTip = true;

new Vue({
  router,
  vuetify,
  i18n,
  store,
  render: h => h(App),
}).$mount('#app');
