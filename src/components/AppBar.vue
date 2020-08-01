<template>
  <div>
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
export default {
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
