import Vue from 'vue';
import VueI18n, { type LocaleMessages } from 'vue-i18n';
Vue.use(VueI18n);

// 言語ファイル読み込み
const loadLocaleMessages = (): LocaleMessages => {
  const locales = require.context(
    '@/locales',
    true,
    /[A-Za-z0-9-_,\s]+\.json$/i
  );

  const messages: LocaleMessages = {};
  locales.keys().forEach(key => {
    const matched = key.match(/([A-Za-z0-9-_]+)\./i);
    if (matched && matched.length > 1) {
      const locale = matched[1];
      messages[locale] = locales(key);
    }
  });
  return messages;
};

export default new VueI18n({
  locale: 'en',
  fallbackLocale: process.env.VUE_APP_I18N_FALLBACK_LOCALE || 'en',
  messages: loadLocaleMessages(),
});
