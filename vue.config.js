/** Vuetify向けvue設定 */
// eslint-disable-next-line @typescript-eslint/no-var-requires
//const TerserPlugin = require('terser-webpack-plugin');

/**
 * @type {import('@vue/cli-service').ProjectOptions}
 */
module.exports = {
  transpileDependencies: ['vuex-persist', 'vuetify'],
  lintOnSave: process.env.NODE_ENV !== 'production',

  configureWebpack: {
    optimization: {
      splitChunks: {
        minSize: 10000,
        maxSize: 250000,
      },
      minimize: process.env.NODE_ENV === 'production',
      /*
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            ascii_only: true,
            compress: { drop_console: true },
            mangle: true,
            ecma: 2020,
            sourceMap: false,
            output: { comments: false, beautify: false },
          },
        }),
      ],
      */
    },
  },
  pluginOptions: {
    i18n: {
      locale: 'en',
      fallbackLocale: 'en',
      localeDir: 'locales',
      enableInSFC: true,
    },
    electronBuilder: {
      preload: 'src/preload.ts',
      disableMainProcessTypescript: false,
      mainProcessTypeChecking: false,
      nodeIntegration: true,
      chainWebpackRendererProcess: config => {
        // Chain webpack config for electron renderer process only
        // The following example will set IS_ELECTRON to true in your app
        config.plugin('define').tap(args => {
          args[0].IS_ELECTRON = true;
          return args;
        });
      },
      builderOptions: {
        mac: {
          icon: 'build/icon.png',
          target: 'zip',
        },
        win: {
          icon: 'build/icon.png',
        },
      },
    },
    lintStyleOnBuild: true,
    stylelint: {},
  },
};
