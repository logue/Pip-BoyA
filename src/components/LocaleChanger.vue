<template>
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
      <v-list-item-group v-model="$i18n.locale">
        <v-list-item
          v-for="(value, key, i) in languages"
          :key="i"
          :value="key"
          mandatory
          @click="changeLocale(key)"
        >
          <v-list-item-title class="locale-item">
            <country-flag :country="value" size="small" />
            <span>{{ $t(`locales.${key}`) }}</span>
          </v-list-item-title>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-menu>
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
      this.$store.commit(
        'setMessage',
        this.$t('locale-changed', {locale: this.$t(`locales.${locale}`)})
      );
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
