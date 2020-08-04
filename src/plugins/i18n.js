import Vue from 'vue';
import VueI18n from 'vue-i18n';

Vue.use(VueI18n);

// 言語ファイル読み込み
const loadLocaleMessages = () => {
  const locales = require.context(
    '../locales',
    true,
    /[A-Za-z0-9-_,\s]+\.json$/i
  );
  const messages = {};
  locales.keys().forEach((key) => {
    const matched = key.match(/([A-Za-z0-9-_]+)\./i);
    if (matched && matched.length > 1) {
      const locale = matched[1];
      messages[locale] = locales(key);
    }
  });
  return messages;
};

export default new VueI18n({
  // デフォルトのロケールは、ブラウザの優先言語
  locale:
    (window.navigator.languages && window.navigator.languages[0]) ||
    window.navigator.language ||
    window.navigator.userLanguage ||
    window.navigator.browserLanguage,
  fallbackLocale: 'en',
  messages: loadLocaleMessages(),
});
