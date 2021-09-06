<template>
  <v-menu offset-y>
    <template #activator="{ on: menu, attrs }">
      <v-tooltip bottom>
        <template #activator="{ on: tooltip }">
          <v-btn icon v-bind="attrs" v-on="{ ...tooltip, ...menu }">
            <v-icon>mdi-translate</v-icon>
          </v-btn>
        </template>
        {{ $t('locale') }}
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
            {{ $t(`locales.${key}`) }}
          </v-list-item-title>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-menu>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import CountryFlag from 'vue-country-flag';
import { languages } from '@/helpers/Utility';
/**
 * Language selector
 */
@Component({
  components: {
    CountryFlag,
  },
})
export default class LocaleChanger extends Vue {
  private readonly languages = languages;

  /** Change locale */
  public changeLocale(locale: string): void {
    this.$i18n.locale = locale;
    if (process.env.IS_ELECTRON) {
      this.$electron.ipcRenderer.send('setLocale', locale);
    }
    this.$store.commit('ConfigModule/setLocale', locale);
    this.$store.commit(
      'setMessage',
      this.$t('locale-changed', { locale: this.$t(`locales.${locale}`) })
    );
  }
}
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
