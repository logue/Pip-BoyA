/* eslint-disable @typescript-eslint/no-var-requires */
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

    <v-snackbar
      v-model="snackbar"
      timeout="5000"
      transition="scroll-y-transition"
      top
    >
      {{ snackbarText }}
      <template #action="{ attrs }">
        <v-btn color="primary" text v-bind="attrs" @click="snackbar = false">
          {{ $t('close') }}
        </v-btn>
      </template>
    </v-snackbar>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import Drawer from '@/components/Drawer.vue';
import AppBar from '@/components/AppBar.vue';

/**
 * App
 * @vuese
 */
@Component({
  components: {
    d: Drawer,
    appbar: AppBar,
  },
})
export default class App extends Vue {
  /** window title */
  private title: string = this.$t('title');
  /** drawer menu visibility */
  private drawer = false;
  /** snackbar visibility */
  private snackbar = false;

  /** theme dark mode */
  private get '$vuetify.theme.dark'(): boolean {
    return this.$store.getters['ConfigModule/toggleTheme'];
  }
  /** current locale */
  private get '$i18n.locale'(): string {
    return this.$store.getters['ConfigModule/locale'];
  }
  /** snackbar text */
  private get snackbarText(): string {
    return this.$store.getters.message;
  }
  /** progress percentage */
  private get progress(): number {
    return this.$store.getters.progress;
  }
  /** loading overlay */
  private get loading(): boolean {
    return this.$store.getters.loading;
  }
  /** Error Message */
  private get error(): boolean {
    return this.$store.getters.error;
  }
  /** Toggle Theme Dark/Light mode */
  private get themeDark(): boolean {
    return this.$store.getters['ConfigModule/themeDark'];
  }

  /** Theme Changer */
  @Watch('themeDark')
  private onThemeChanged(): void {
    // console.log('theme changed');
    this.$vuetify.theme.dark = this.$store.getters['ConfigModule/themeDark'];
  }
  /** locale changer */
  @Watch('$i18n.locale')
  private onLocaleChanged(): void {
    // change title bar text
    const title = this.$t('title');
    const locale = this.$i18n.locale;
    this.title = document.title = process.env.IS_ELECTRON
      ? title.replace(/Web/g, 'Electron')
      : title;
    // change language
    document.documentElement.lang = locale;
    // change description
    document
      .getElementsByName('description')
      .item(0)
      .setAttribute('content', this.$t('description'));

    // change electron runtime locale (not works!)
    if (process.env.IS_ELECTRON) {
      this.$electron.ipcRenderer.sendSync('setLocale', locale);
    }
  }
  /** Modify snackbar text */
  @Watch('$store.getters.message')
  private onSnackbarTextChanged(): void {
    this.snackbar = true;
  }
  /** when route change, hide snackbar */
  @Watch('$route')
  private onRouteChanged(): void {
    this.snackbar = false;
  }
  /** when loading */
  @Watch('loading')
  private onLoading(): void {
    // change cursor
    document.body.style.cursor = this.loading ? 'wait' : 'auto';
    // hide drawer menu while loading.
    const drawer: boolean = this.drawer;
    if (this.loading) {
      this.drawer = false;
    } else {
      this.drawer = drawer;
      if (process.env.IS_ELECTRON) {
        // hide progress when finish loading.
        this.$electron.ipcRenderer.send('setProgress', 0);
      }
    }
    this.$forceNextTick();
  }

  @Watch('progress')
  private onProgressChanged() {
    if (process.env.IS_ELECTRON) {
      this.$electron.ipcRenderer.send('setProgress', this.progress);
    }
    this.$forceNextTick();
  }

  @Watch('error')
  private onError() {
    this.$router.push({ name: 'Error' });
  }

  /** run once. */
  private mounted() {
    this.$vuetify.theme.dark = this.$store.getters['ConfigModule/themeDark'];
    this.$i18n.locale = this.$store.getters['ConfigModule/locale'];
    document.title = this.title;
  }

  /*
  private throttledYield = throttle => {
    let lastYield: number = new Date().getUTCSeconds();
    return async () => {
      const now: number = new Date().getUTCSeconds();
      if (now - lastYield >= throttle) {
        lastYield = now;
        await this.sleep();
      }
    };
  };
  private sleep = (): Promise<void> =>
    new Promise(resolve => {
      requestAnimationFrame(resolve);
    });
  */
}
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
