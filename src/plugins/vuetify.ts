import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';
import i18n from './i18n';

// ロケール
import locale from 'vuetify/es5/locale';

import '@fontsource/noto-sans-jp';
import '@mdi/font/scss/materialdesignicons.scss';
import { VuetifyParsedTheme } from 'vuetify/types/services/theme';

Vue.use(Vuetify);

export default new Vuetify({
  lang: {
    locales: locale,
    t: (key, ...params) => i18n.t(key, params),
  },
  theme: {
    options: {
      themeCache: {
        get: (key: VuetifyParsedTheme) =>
          localStorage.getItem(key as unknown as string),
        set: (key: VuetifyParsedTheme, value: string) =>
          localStorage.setItem(key as unknown as string, value),
      },
    },
  },
});
