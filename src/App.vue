<template>
  <v-app class="pip-boya">
    <v-app-bar app dense>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title>{{ $root.$data.title }}</v-toolbar-title>
      <v-spacer />
      <appbar />
    </v-app-bar>

    <v-navigation-drawer v-model="drawer" app left>
      <d />
    </v-navigation-drawer>

    <v-main>
      <v-fade-transition mode="out-in">
        <router-view />
      </v-fade-transition>
    </v-main>

    <v-overlay :value="$root.$data.loading">
      <v-progress-circular indeterminate size="64" />
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
    return {
      title: null,
      drawer: false,
      explain: false,
    };
  },
  computed: {
    '$vuetify.theme.dark'() {
      return this.$store.state.config.themeDark;
    },
    '$i18n.locale'() {
      return this.$store.state.config.locale;
    },
  },
  mounted() {
    document.title = this.$root.$data.title;
    // 設定を反映
    this.$vuetify.theme.dark = this.$store.state.config.themeDark;
    this.$i18n.locale = this.$store.state.config.locale;
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
