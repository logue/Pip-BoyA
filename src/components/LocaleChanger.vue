<template>
  <v-list-item-group v-model="$i18n.locale">
    <v-list-item
      v-for="(lang, i) in langs"
      :key="`Lang${i}`"
      :value="lang"
      mandatory
      @click="changeLocale(lang)"
    >
      <v-list-item-title>
        {{ $t(`locales.${lang}`) }}
      </v-list-item-title>
    </v-list-item>
  </v-list-item-group>
</template>

<script>
export default {
  name: 'LocaleChanger',
  data() {
    return {
      langs: Object.keys(this.$i18n.messages),
    };
  },
  methods: {
    changeLocale(locale) {
      this.$i18n.locale = locale;
      this.$store.commit('config/setLocale', locale);
    },
  },
};
</script>
