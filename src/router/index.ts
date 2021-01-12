import Vue from 'vue';
import VueRouter, { Route, RouteConfig } from 'vue-router';
import goTo from 'vuetify/lib/services/goto';

import Home from '@/views/Home.vue';
import { Position } from 'vue-router/types/router';

Vue.use(VueRouter);

const routes: RouteConfig[] = [
  {
    path: '/',
    name: 'Home',
    component: Home,
  },
  {
    path: '/:category',
    name: 'Category',
    component: Home,
  },
];

const router: VueRouter = new VueRouter({
  mode: process.env.IS_ELECTRON ? 'hash' : 'history',
  base: process.env.BASE_URL,
  scrollBehavior: (to: Route, from: Route, savedPosition: void | Position) => {
    let scrollTo: number | string = 0;

    if (to.hash) {
      scrollTo = to.hash;
    } else if (savedPosition) {
      scrollTo = savedPosition.y;
    }

    return goTo(scrollTo);
  },
  routes,
});

/*
// @see https://github.com/championswimmer/vuex-persist#how-to-know-when-async-store-has-been-replaced
router.beforeEach(
  async (to: Route, from: Route, next: NavigationGuardNext<Vue>) => {
    await store.restored;
    next();
  }
);
*/
export default router;
