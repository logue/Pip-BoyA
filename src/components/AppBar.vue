<template>
  <div>
    <!-- Normal mode -->
    <div class="d-none d-sm-flex d-sm-none d-md-flex">
      <!-- About -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.about.open()">
            <v-icon>mdi-information-outline</v-icon>
          </v-btn>
        </template>
        <span>About</span>
      </v-tooltip>
      <!-- Get Link -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.getLink.open()">
            <v-icon>mdi-share-variant</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('getUri') }}</span>
      </v-tooltip>
      <!-- Toggle Location Marker -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.commit('config/toggleLocationMarker')"
          >
            <v-icon v-if="$store.state.config.displayLocation">
              mdi-map-marker-outline
            </v-icon>
            <v-icon v-else>mdi-map-marker-off-outline</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleLocation') }}</span>
      </v-tooltip>
      <!-- Toggle WebGL -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.commit('config/toggleWebGl')"
          >
            <v-icon v-if="$store.state.config.webgl">mdi-cube-outline</v-icon>
            <v-icon v-else>mdi-cube-off-outline</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleWebGl') }}</span>
      </v-tooltip>
      <!-- Toggle Map -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.commit('config/toggleMap')"
          >
            <v-icon v-if="$store.state.config.isMilitary">
              mdi-map-outline
            </v-icon>
            <v-icon v-else>mdi-map-legend</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleMap') }}</span>
      </v-tooltip>
      <!-- Toggle Dark mode -->
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.commit('config/toggleTheme')"
          >
            <v-icon>mdi-invert-colors</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleDarkMode') }}</span>
      </v-tooltip>
      <!-- Locale Menu -->
      <v-menu offset-y>
        <template #activator="{on: menu, attrs}">
          <v-tooltip bottom>
            <template #activator="{on: tooltip}">
              <v-btn icon v-bind="attrs" v-on="{...tooltip, ...menu}">
                <v-icon>mdi-translate</v-icon>
              </v-btn>
            </template>
            <span>{{ $t('locale') }}</span>
          </v-tooltip>
        </template>
        <v-list dense>
          <locale-changer />
        </v-list>
      </v-menu>
    </div>
    <!-- Small window mode -->
    <div class="d-flex d-sm-none">
      <v-menu offset-y>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list dense>
          <!-- About -->
          <v-list-item @click="$refs.about.open()">
            <v-list-item-icon>
              <v-icon>mdi-information-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>About</v-list-item-title>
          </v-list-item>
          <v-divider />
          <!-- Get Link -->
          <v-list-item @click="$refs.getLink.open()">
            <v-list-item-icon>
              <v-icon>mdi-share-variant</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('getUri') }}</v-list-item-title>
          </v-list-item>
          <v-list-item @click="$store.commit('config/toggleLocationMarker')">
            <v-list-item-icon>
              <v-icon v-if="$store.state.config.displayLocation">
                mdi-map-marker-outline
              </v-icon>
              <v-icon v-else>mdi-map-marker-off-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleLocation') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle WebGL -->
          <v-list-item @click="$store.commit('config/toggleWebGl')">
            <v-list-item-icon>
              <v-icon v-if="$store.state.config.webgl">mdi-cube-outline</v-icon>
              <v-icon v-else>mdi-cube-off-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleWebGl') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle Map -->
          <v-list-item @click="$store.commit('config/toggleMap')">
            <v-list-item-icon>
              <v-icon v-if="!$store.state.config.isMilitary">mdi-map</v-icon>
              <v-icon v-else>mdi-map-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleMap') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle Dark mode -->
          <v-list-item @click="$store.commit('config/toggleTheme')">
            <v-list-item-icon>
              <v-icon>mdi-invert-colors</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleDarkMode') }}</v-list-item-title>
          </v-list-item>
          <v-divider />
          <!-- Locale selection -->
          <v-subheader prepend-icon="mdi-translate">
            {{ $t('locale') }}
          </v-subheader>
          <locale-changer />
        </v-list>
      </v-menu>
    </div>
    <!-- dialogs -->
    <about ref="about" />
    <get-link ref="getLink" />
  </div>
</template>

<script>
/**
 * Application Bar.
 */
import About from '@/components/About.vue';
import GetLink from '@/components/GetLink.vue';
import LocaleChanger from '@/components/LocaleChanger.vue';
export default {
  components: {
    about: About,
    'get-link': GetLink,
    'locale-changer': LocaleChanger,
  },
  mounted() {
    this.$store.subscribe((mutation, state) => {
      switch (mutation.type) {
        case 'config/toggleTheme':
          this.$vuetify.theme.dark = state.config.themeDark;
          break;
        case 'config/setLocale':
          this.$i18n.locale = state.config.locale;
          break;
      }
    });
  },
};
</script>
