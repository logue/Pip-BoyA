/** Vuetify向けvue設定 */

/* eslint-disable */
const webpack = require('webpack');
const path = require('path');
const fs = require('fs');
const TerserPlugin = require('terser-webpack-plugin');

// バージョン情報など
const pjson = require('./package.json');
// 現在の時刻（ビルド時刻）
const build = new Date().toISOString();

if (process.env.NODE_ENV === 'production') {
  // Meta.tsを書き込む
  fs.writeFileSync(
    path.resolve(path.join(__dirname, 'src/Meta.ts')),
    `import MetaInterface from './interfaces/MetaInterface';

// This file is auto-generated by the build system.
const meta: MetaInterface = {
  version: '${pjson.version}',
  date: '${build}',
};
export default meta;
`
  );
}
/**
 * @type {import('@vue/cli-service').ProjectOptions}
 */
module.exports = {
  transpileDependencies: ['vuex-persist', 'vuetify'],
  lintOnSave: process.env.NODE_ENV !== 'production',
  productionSourceMap: process.env.NODE_ENV !== 'production',
  configureWebpack: {
    output: {
      hashFunction: 'xxhash64',
    },
    resolve: {
      fallback: {
        path: false,
        fs: false,
        crypto: false,
        stream: false,
      },
    },
    optimization: {
      minimize: process.env.NODE_ENV === 'production',
      splitChunks: {
        minSize: 100000,
        maxSize: 250000,
      },
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            ecma: 2020,
            parse: {},
            compress: { drop_console: true },
            mangle: true, // Note `mangle.properties` is `false` by default.
            module: true,
            parallel: true,
            extractComments: 'all',
            output: { comments: false, beautify: true },
          },
        }),
      ],
    },
    plugins:
      process.env.NODE_ENV === 'production'
        ? [
            new webpack.BannerPlugin({
              banner: `${pjson.name} v${pjson.version} | ${pjson.author.name}<${pjson.author.email}> ${pjson.author.url} | license: ${pjson.license} | build: ${build}`,
            }),
          ]
        : [],
  },
  pluginOptions: {
    i18n: {
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
        config.output.hashFunction = 'xxhash64';
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
