import Vue from 'vue';
import VueGtag from 'vue-gtag';
import router from '@/router';

Vue.use(
  VueGtag,
  {
    config: {
      id: process.env.GOOGLE_ANALYTICS_CODE || 'UA-11445748-24',
    },
    pageTrackerTemplate(to) {
      console.log(to);
      return {
        page_title: document.title,
        page_path: to.path,
      };
    },
    pageTrackerScreenviewEnabled: true,
  },
  router
);
