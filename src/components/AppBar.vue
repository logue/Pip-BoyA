<template>
  <div class="">
    <!-- Normal mode -->
    <div class="d-none d-sm-flex d-sm-none d-md-flex">
      <!-- About -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.about.open()">
            <v-icon>mdi-information-outline</v-icon>
          </v-btn>
        </template>
        {{ $t('about', { appname: $t('title') }) }}
      </v-tooltip>
      <!-- Get Link -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on" @click="$refs.getLink.open()">
            <v-icon>mdi-share-variant-outline</v-icon>
          </v-btn>
        </template>
        {{ $t('getUri') }}
      </v-tooltip>
      <!-- Toggle Location Marker -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.dispatch('ConfigModule/toggleLocationMarker')"
          >
            <v-icon v-if="$store.getters['ConfigModule/displayLocation']">
              mdi-map-marker-outline
            </v-icon>
            <v-icon v-else>mdi-map-marker-off-outline</v-icon>
          </v-btn>
        </template>
        {{ $t('toggleLocation') }}
      </v-tooltip>
      <!-- Toggle WebGL -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.dispatch('ConfigModule/toggleWebGl')"
          >
            <v-icon v-if="$store.getters['ConfigModule/webgl']">
              mdi-cube-outline
            </v-icon>
            <v-icon v-else>mdi-cube-off-outline</v-icon>
          </v-btn>
        </template>
        {{ $t('toggleWebGl') }}
      </v-tooltip>
      <!-- Toggle Map -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.dispatch('ConfigModule/toggleMap')"
          >
            <v-icon v-if="$store.getters['ConfigModule/mapType'] === 2">
              mdi-map
            </v-icon>
            <v-icon v-else-if="$store.getters['ConfigModule/mapType'] === 1">
              mdi-map-legend
            </v-icon>
            <v-icon v-else>mdi-map-outline</v-icon>
          </v-btn>
        </template>
        {{ $t('toggleMap') }}
      </v-tooltip>
      <!-- Toggle Dark mode -->
      <v-tooltip bottom>
        <template #activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
            @click="$store.dispatch('ConfigModule/toggleTheme')"
          >
            <v-icon>mdi-invert-colors</v-icon>
          </v-btn>
        </template>
        {{ $t('toggleDarkMode') }}
      </v-tooltip>
      <!-- Locale Menu -->
      <locale-changer />
    </div>
    <div class="d-flex d-sm-none">
      <!-- Small window mode -->
      <v-menu offset-y>
        <template #activator="{ on, attrs }">
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
            <v-list-item-title>
              {{ $t('about', { appname: $t('title') }) }}
            </v-list-item-title>
          </v-list-item>
          <v-divider />
          <!-- Get Link -->
          <v-list-item @click="$refs.getLink.open()">
            <v-list-item-icon>
              <v-icon>mdi-share-variant-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('getUri') }}</v-list-item-title>
          </v-list-item>
          <v-list-item
            @click="$store.dispatch('ConfigModule/toggleLocationMarker')"
          >
            <v-list-item-icon>
              <v-icon v-if="$store.getters['ConfigModule/displayLocation']">
                mdi-map-marker-outline
              </v-icon>
              <v-icon v-else>mdi-map-marker-off-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleLocation') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle WebGL -->
          <v-list-item @click="$store.dispatch('ConfigModule/toggleWebGl')">
            <v-list-item-icon>
              <v-icon v-if="$store.getters['ConfigModule/webgl']">
                mdi-cube-outline
              </v-icon>
              <v-icon v-else>mdi-cube-off-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleWebGl') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle Map -->
          <v-list-item @click="$store.dispatch('ConfigModule/toggleMap')">
            <v-list-item-icon>
              <v-icon v-if="$store.getters['ConfigModule/mapType'] === 2">
                mdi-map
              </v-icon>
              <v-icon v-else-if="$store.getters['ConfigModule/mapType'] === 1">
                mdi-map-legend
              </v-icon>
              <v-icon v-else>mdi-map-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleMap') }}</v-list-item-title>
          </v-list-item>
          <!-- Toggle Dark mode -->
          <v-list-item @click="$store.dispatch('ConfigModule/toggleTheme')">
            <v-list-item-icon>
              <v-icon>mdi-invert-colors</v-icon>
            </v-list-item-icon>
            <v-list-item-title>{{ $t('toggleDarkMode') }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <!-- Locale Menu -->
      <locale-changer />
    </div>
    <!-- dialogs -->
    <about ref="about" />
    <get-link ref="getLink" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import About from '@/components/About.vue';
import GetLink from '@/components/GetLink.vue';
import LocaleChanger from '@/components/LocaleChanger.vue';
/**
 * Application Bar.
 */
@Component({
  components: {
    about: About,
    'get-link': GetLink,
    'locale-changer': LocaleChanger,
  },
})
export default class AppBar extends Vue {}
</script>
