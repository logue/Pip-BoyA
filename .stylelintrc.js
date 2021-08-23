module.exports = {
  root: true,
  extends: ['stylelint-config-standard', 'stylelint-prettier/recommended'],
  plugin: ['stylelint-scss'],
  rules: {
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: [
          'function',
          'if',
          'for',
          'each',
          'include',
          'mixin',
          'content',
          'return',
        ],
      },
    ],
  },
};
