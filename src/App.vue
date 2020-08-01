<template>
  <v-app>
    <v-navigation-drawer
      v-model="primaryDrawer.model"
      :clipped="primaryDrawer.clipped"
      :floating="primaryDrawer.floating"
      :mini-variant="primaryDrawer.mini"
      :permanent="primaryDrawer.type === 'permanent'"
      :temporary="primaryDrawer.type === 'temporary'"
      app
      overflow
    >
      <d />
    </v-navigation-drawer>

    <v-app-bar :clipped-left="primaryDrawer.clipped" app dense>
      <v-app-bar-nav-icon
        v-if="primaryDrawer.type !== 'permanent'"
        @click.stop="primaryDrawer.model = !primaryDrawer.model"
      />
      <v-toolbar-title>Mappalachia for Web</v-toolbar-title>
      <v-spacer />
      <appbar />
    </v-app-bar>

    <v-main>
      <v-fade-transition mode="out-in">
        <router-view />
      </v-fade-transition>
    </v-main>
  </v-app>
</template>

<script>
import Drawer from '@/components/Drawer.vue';
import AppBar from '@/components/AppBar.vue';

/**
 * App
 * @vuese
 */
export default {
  components: {
    d: Drawer,
    appbar: AppBar,
  },
  data: () => ({
    drawer: null,
    primaryDrawer: {
      model: null,
      type: 'default (no property)',
      clipped: false,
      floating: false,
      mini: false,
    },
    locales: ['ja', 'en'],
  }),
  created() {},
};
</script>
