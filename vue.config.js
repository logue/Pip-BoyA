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

  chainWebpack: (config) => {
    config.module
      .rule('worker-loader')
      .test(/\.worker\.js$/i)
      .use('worker-loader')
      .loader('worker-loader')
      .end();
  },

  pluginOptions: {
    i18n: {
      locale: 'en',
      fallbackLocale: 'en',
      localeDir: 'locales',
      enableInSFC: true,
    },
    electronBuilder: {
      nodeIntegration: true,
      chainWebpackRendererProcess: (config) => {
        // Chain webpack config for electron renderer process only
        // The following example will set IS_ELECTRON to true in your app
        config.plugin('define').tap((args) => {
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
  },
};
