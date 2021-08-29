module.exports = {
  root: true,
  env: {
    browser: true,
    es6: true,
    node: true,
  },
  extends: [
    'plugin:vue/recommended',
    '@vue/typescript/recommended',
    '@vue/prettier',
    '@vue/prettier/@typescript-eslint',
    'plugin:vue/essential',
    'eslint:recommended',
    '@vue/typescript',
    './node_modules/gts'
  ],
  plugins: ['vue', '@typescript-eslint/eslint-plugin', 'eslint-plugin-tsdoc'],
  parserOptions: {
    ecmaVersion: 2020,
    parser: '@typescript-eslint/parser',
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'node/no-missing-import': 'off',
    'node/no-unpublished-import': 'off',
    'node/no-unpublished-require': 'off',
    'node/no-unsupported-features/es-syntax': 'off',
    'node/no-unsupported-features/node-builtins': 'off',
    'node/no-extraneous-import': 'error',
  },
  settings: {
    node: {
      allowModules: ['electron', 'ol'],
      resolvePaths: [__dirname],
      tryExtensions: ['.js', '.json', '.node'],
    },
  },
  overrides: [
    {
      files: ['*.js'],
      rules: {
        // Allow `require()`
        '@typescript-eslint/no-var-requires': 'off',
      },
    },
  ],
};
