import Vue from 'vue';
import VueGtag from 'vue-gtag';
import router from '@/router';

Vue.use(
  VueGtag,
  {
    id: process.env.GOOGLE_ANALYTICS_CODE || 'UA-11445748-24',
  },
  router
);
