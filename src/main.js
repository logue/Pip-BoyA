import Vue from 'vue';
import App from './App.vue';
import router from './router';
import i18n from './plugins/i18n';

import vuetify from './plugins/vuetify';
import './plugins/vuelayers';
import './plugins/axios';

Vue.config.productionTip = false;

new Vue({
  data() {
    return {
      isMilitary: false,
    };
  },
  router,
  vuetify,
  i18n,
  render: (h) => h(App),
}).$mount('#app');
