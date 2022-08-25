import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';
import i18n from './i18n';

// ロケール
import {
  de,
  en,
  es,
  fr,
  it,
  ja,
  ko,
  pl,
  pt,
  ru,
  zhHans,
  zhHant,
} from 'vuetify/lib/locale';

import '@fontsource/noto-sans-jp';
import '@mdi/font/scss/materialdesignicons.scss';

Vue.use(Vuetify);

export default new Vuetify({
  lang: {
    locales: { de, en, es, fr, it, ja, ko, pl, pt, ru, zhHans, zhHant },
    t: (key, ...params) => i18n.t(key, params),
  },
  theme: {
    options: {
      themeCache: {
        get: key => localStorage.getItem(key as unknown as string),
        set: (key, value: string) =>
          localStorage.setItem(key as unknown as string, value),
      },
    },
  },
});
