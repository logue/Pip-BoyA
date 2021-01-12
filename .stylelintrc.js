module.exports = {
  root: true,
  plugins: ['stylelint-scss'],
  extends: ['stylelint-config-standard'],
  rules: {
    indentation: 2,
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: ['function', 'if', 'each', 'include', 'mixin', 'return'],
      },
    ],
    'scss/at-rule-no-unknown': true,
    'function-calc-no-invalid': null,
  },
};
