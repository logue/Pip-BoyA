<template>
  <v-list-item-group v-model="$i18n.locale">
    <v-list-item
      v-for="(value, key, i) in languages"
      :key="i"
      :value="key"
      mandatory
      @click="changeLocale(key)"
    >
      <v-list-item-title class="locale-item">
        <country-flag :country="value" size="normal" />
        <span>{{ $t(`locales.${key}`) }}</span>
      </v-list-item-title>
    </v-list-item>
  </v-list-item-group>
</template>

<script>
import CountryFlag from 'vue-country-flag';

export default {
  name: 'LocaleChanger',
  components: {
    CountryFlag,
  },
  data() {
    return {
      languages: {
        de: 'de',
        en: 'gb',
        es: 'es',
        fr: 'fr',
        it: 'it',
        ja: 'jp',
        ko: 'kr',
        pl: 'pl',
        pt: 'pt',
        ru: 'ru',
        'zh-cn': 'cn',
        'zh-tw': 'tw',
      },
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

<style lang="scss" scoped>
.locale-item {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  > span {
    display: block;
  }
}
</style>
