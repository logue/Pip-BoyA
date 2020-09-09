<template>
  <div>
    <div class="d-none d-sm-flex d-sm-none d-md-flex">
      <about ref="about" />
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.about.open()">
            <v-icon>mdi-information-outline</v-icon>
          </v-btn>
        </template>
        <span>About</span>
      </v-tooltip>
      <get-link ref="getLink" />
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.getLink.open()">
            <v-icon>mdi-link</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('getUri') }}</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="toggleLocation($root.$data.displayLocation)"
          >
            <v-icon v-if="$root.$data.displayLocation">mdi-map-marker</v-icon>
            <v-icon v-else>mdi-map-marker-off</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleLocation') }}</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="toggleMapMode($root.$data.isMilitary)"
          >
            <v-icon v-if="!$root.$data.isMilitary">mdi-map</v-icon>
            <v-icon v-else>mdi-map-outline</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleMap') }}</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template #activator="{on, attrs}">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="toggleThemeMode($vuetify.theme.dark)"
          >
            <v-icon>mdi-invert-colors</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleDarkMode') }}</span>
      </v-tooltip>
      <v-menu offset-y>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-translate</v-icon>
          </v-btn>
        </template>
        <v-list v-model="$i18n.locale">
          <v-list-item
            v-for="locale in locales"
            :key="locale"
            @click="changeLocale(locale)"
          >
            <v-list-item-title>{{ $t(`locales.${locale}`) }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
    <div class="d-flex d-sm-none">
      <v-menu offset-y>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list dense>
          <v-list-item @click="$refs.about.open()">
            <v-list-item-icon>
              <v-icon>mdi-information-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>About</v-list-item-title>
          </v-list-item>
          <v-divider />
          <v-list-item @click="$refs.getLink.open()">
            <v-list-item-icon>
              <v-icon>mdi-link</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('getUri') }}</v-list-item-title>
          </v-list-item>
          <v-list-item @click="toggleLocation($root.$data.displayLocation)">
            <v-list-item-icon>
              <v-icon v-if="$root.$data.displayLocation">mdi-map-marker</v-icon>
              <v-icon v-else>mdi-map-marker-off</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleLocation') }}</v-list-item-title>
          </v-list-item>
          <v-list-item @click="toggleMapMode($root.$data.isMilitary)">
            <v-list-item-icon>
              <v-icon v-if="!$root.$data.isMilitary">mdi-map</v-icon>
              <v-icon v-else>mdi-map-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleMap') }}</v-list-item-title>
          </v-list-item>
          <v-list-item @click="toggleThemeMode($vuetify.theme.dark)">
            <v-list-item-icon>
              <v-icon>mdi-invert-colors</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleDarkMode') }}</v-list-item-title>
          </v-list-item>
          <v-divider />
          <v-subheader prepend-icon="mdi-translate" inset>
            {{ $t('locale') }}
          </v-subheader>
          <v-list-item
            v-for="locale in locales"
            :key="locale"
            @click="changeLocale(locale)"
          >
            <v-list-item-title>
              {{ $t(`locales.${locale}`) }}
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
  </div>
</template>

<script>
/**
 * Application Bar.
 */
import About from '@/components/About.vue';
import GetLink from '@/components/GetLink.vue';

export default {
  components: {
    about: About,
    'get-link': GetLink,
  },
  data() {
    return {
      locales: Object.keys(this.$i18n.messages),
    };
  },
  methods: {
    toggleThemeMode(value) {
      this.$vuetify.theme.dark = !value;
      this.$cookies.set('theme', this.$vuetify.theme.dark);
    },
    toggleMapMode(value) {
      this.$root.$data.isMilitary = !value;
      this.$cookies.set('military-map', this.$root.$data.isMilitary);
    },
    toggleLocation(value) {
      this.$root.$data.displayLocation = !value;
      this.$cookies.set('display-location', this.$root.$data.displayLocation);
    },
    changeLocale(locale) {
      this.$i18n.locale = locale;
      this.$cookies.set('locale', locale);
    },
  },
};
</script>
