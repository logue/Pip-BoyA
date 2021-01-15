/* eslint-disable */
const TerserPlugin = require('terser-webpack-plugin');
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
      disableMainProcessTypescript: false, // Manually disable typescript plugin for main process. Enable if you want to use regular js for the main process (src/background.js by default).
      mainProcessTypeChecking: false, // Manually enable type checking during webpck bundling for background file.
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
    lintStyleOnBuild: false,
    stylelint: {},
  },
};
