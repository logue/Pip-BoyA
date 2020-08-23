const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  transpileDependencies: ['vuetify'],

  configureWebpack: {
    optimization: {
      minimize: process.env.NODE_ENV === 'production',
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            ascii_only: true,
            compress: {
              drop_console: true,
            },
            mangle: true,
            ecma: 6,
            sourceMap: false,
            output: {
              comments: false,
              beautify: false,
            },
          },
        }),
      ],
    },
  },

  pluginOptions: {
    i18n: {
      // locale: 'ja',
      fallbackLocale: 'en',
      localeDir: 'locales',
      enableInSFC: false,
    },
    electronBuilder: {
      nodeIntegration: true,
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
  },
};
