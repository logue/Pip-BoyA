import Vue from 'vue';
import VueElectron from 'vue-electron';

if (process.env.IS_ELECTRON) {
  Vue.use(VueElectron);
}
