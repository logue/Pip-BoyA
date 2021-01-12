import Vue from 'vue';
import VueAnalytics, { set } from 'vue-analytics';
import router from '@/router';
import { Route } from 'vue-router';

Vue.use(VueAnalytics, {
  id: 'UA-11445748-24',
  router,
  debug: {
    enabled: false,
    trace: false, // help you find problems
  },
  fields: {
    cookieDomain: 'none', // no domain
  },
  autoTracking: {
    pageviewTemplate(route: Route) {
      // allow custom page titles in the router meta
      return {
        page: route.params.category || route.name,
        title: document.title,
        location: route.path,
      };
    },
  },
});
set('allowAdFeatures', false); // no ads
set('checkProtocolTask', true); // ignore electron protocols
set('checkStorageTask', true); // ignore electrons cache solution, assume it works
