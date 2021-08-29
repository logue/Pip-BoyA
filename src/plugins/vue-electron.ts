import Vue from 'vue';

if (process.env.IS_ELECTRON) {
  const VueElectron = require('vue-electron');
  Vue.use(VueElectron);
}
