<template>
  <v-app class="pip-boya">
    <v-navigation-drawer v-model="drawer" app left>
      <d />
    </v-navigation-drawer>

    <v-app-bar app dense>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title>{{ title }}</v-toolbar-title>
      <v-spacer />
      <appbar />
      <v-progress-linear
        :active="loading"
        :indeterminate="progress === null"
        :value="progress"
        absolute
        bottom
        color="blue accent-3"
      />
    </v-app-bar>

    <v-main>
      <v-fade-transition mode="out-in">
        <router-view />
      </v-fade-transition>
    </v-main>

    <v-overlay v-model="loading">
      <v-progress-circular indeterminate size="64" />
    </v-overlay>

    <v-snackbar v-model="snackbar" timeout="5000" top>
      {{ snackbarText }}
      <template #action="{attrs}">
        <v-btn color="primary" text v-bind="attrs" @click="snackbar = false">
          {{ $t('close') }}
        </v-btn>
      </template>
    </v-snackbar>
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
      title: this.$t('title'),
      drawer: false,
      snackbar: false,
    };
  },
  computed: {
    '$vuetify.theme.dark'() {
      return this.$store.getters['config/themeDark'];
    },
    '$i18n.locale'() {
      return this.$store.getters['config/locale'];
    },
    snackbarText() {
      return this.$store.getters.message;
    },
    progress() {
      return this.$store.getters.progress;
    },
    loading() {
      const loading = this.$store.getters.loading;
      document.body.style.cursor = loading ? 'wait' : 'auto';
      return loading;
    },
  },
  watch: {
    '$i18n.locale'() {
      const title = this.$t('title');
      this.title = document.title = process.env.IS_ELECTRON
        ? title.replace(/Web/g, 'Electron')
        : title;
      document.documentElement.lang = this.$i18n.locale;
      document.getElementsByName('description')[0].content = this.$t(
        'description'
      );
    },
    '$store.getters.message'() {
      this.snackbar = true;
    },
    $route() {
      this.snackbar = false;
    },
  },
  mounted() {
    // 設定を反映
    this.$vuetify.theme.dark = this.$store.getters['config/themeDark'];
    this.$i18n.locale = this.$store.getters['config/locale'];
    document.title = this.title;
  },
};
</script>

<style lang="scss">
html,
body,
#app {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

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
