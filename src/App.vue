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
      <v-toolbar-title>Vuetify</v-toolbar-title>
      <v-spacer></v-spacer>

      <v-btn icon @click="toggleThemeMode">
        <v-icon>mdi-invert-colors</v-icon>
      </v-btn>
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

/**
 * App
 * @vuese
 */
export default {
  components: {
    d: Drawer,
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
  }),
  created() {},
  methods: {
    toggleThemeMode() {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
    },
  },
};
</script>
