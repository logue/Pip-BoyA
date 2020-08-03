<template>
  <div>
    <about ref="about" />
    <v-btn icon @click="$refs.about.open()">
      <v-icon>mdi-information-outline</v-icon>
    </v-btn>
    <get-link ref="getLink" />
    <v-btn icon @click="$refs.getLink.open()">
      <v-icon>mdi-link</v-icon>
    </v-btn>
    <v-btn icon @click="toggleMapMode">
      <v-icon v-if="!$root.$data.isMilitary">mdi-map</v-icon>
      <v-icon v-else>mdi-map-outline</v-icon>
    </v-btn>
    <v-btn icon @click="toggleThemeMode">
      <v-icon>mdi-invert-colors</v-icon>
    </v-btn>
  </div>
</template>

<script>
import About from '@/components/About.vue';
import GetLink from '@/components/GetLink.vue';

export default {
  components: {
    about: About,
    'get-link': GetLink,
  },
  methods: {
    toggleThemeMode() {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
    },
    toggleMapMode() {
      this.$root.$data.isMilitary = !this.$root.$data.isMilitary;
    },
  },
};
</script>
