<template>
  <v-app class="pip-boya">
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

    <v-overlay :value="$root.$data.loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
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
  data() {
    document.title = this.$t('title');
    if (process.env.IS_ELECTRON) {
      document.title.replace('Web', 'Electron');
    }
    this.$i18n.locale = this.$cookies.get('locale') || 'en';
    return {
      drawer: null,
      primaryDrawer: {
        model: null,
        type: 'default (no property)',
        clipped: false,
        floating: false,
        mini: false,
      },
      locales: ['ja', 'en'],
    };
  },
};
</script>

<style lang="scss">
::-webkit-scrollbar {
  width: 0.75rem;
  background-color: rgba(map-get($grey, 'lighten-1'), 1);
}

::-webkit-scrollbar-thumb {
  border-radius: 10px;
  box-shadow: inset 0 0 0.25rem rgba(map-get($grey, 'base'), 0.1);
  background-color: map-get($grey, 'darken-1');
}

.theme--dark.v-application {
  background: map-get($grey, 'darken-4') !important;
  color: map-get($grey, 'lighten-1') !important;
}

.theme--light.v-application {
  background: map-get($grey, 'lighten-1') !important;
  color: map-get($grey, 'darken-4') !important;
}
</style>
