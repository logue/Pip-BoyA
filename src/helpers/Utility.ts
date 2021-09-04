/**
 * Country icon mapping
 */
export const languages: { [key: string]: string } = {
  de: 'de',
  en: 'gb',
  es: 'es',
  fr: 'fr',
  it: 'it',
  ja: 'jp',
  ko: 'kr',
  pl: 'pl',
  ru: 'ru',
  'zh-cn': 'cn',
  'zh-tw': 'tw',
};

/**
 * Convert hex color code to rgb array.
 *
 * @param hex HEX Color code (#FFFFFF)
 * @return rgb array [255, 255, 255]
 */
export function hexToRgb(hex: string): number[] {
  if (hex) {
    const ret = hex
      .replace(
        /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
        (_m, r, g, b) => '#' + r + r + g + g + b + b
      )
      .substring(1)
      .match(/.{2}/g);
    if (ret) {
      return ret.map(x => parseInt(x, 16));
    }
  }
  throw RangeError('Invalied color code.');
}

/**
 * kebab-case to camelCase
 *
 * @param s kebab-case string
 * @return camelCase String
 */
export function toCamelCase(s: string): string {
  if (!s) return '';
  return s.replace(/-./g, x => x.toUpperCase()[1]);
}

/**
 * values of
 * @param {Object} obj Hashed Array
 * @return {mixed}
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function valuesOf(obj: any): { [key: string]: any } {
  return Object.keys(obj).map((key: string) => obj[key]);
}

/**
 * Open External Window.
 * @param href link href
 */
export function openWindow(href: string): void {
  if (process.env.IS_ELECTRON) {
    const { shell } = require('electron');
    // Open browser
    shell.openExternal(href);
  } else {
    window.open(href);
  }
}

/**
 * Copy to Clipboard
 * @param text copy to text
 */
export function copy(text: string): void {
  if (process.env.IS_ELECTRON) {
    const { clipboard } = require('electron');
    clipboard.writeText(text);
  } else {
    navigator.clipboard.writeText(text);
  }
}

/**
 * Set execution frequency
 * @param throttle Execution frequency (ms)
 */
export function throttledYield(throttle = 24) {
  let lastYield: number = new Date().getUTCSeconds();
  return async () => {
    const now: number = new Date().getUTCSeconds();
    if (now - lastYield >= throttle) {
      lastYield = now;
      await sleep();
    }
  };
}

/**
 * 待機処理.
 * @returns ?
 */
export function sleep() {
  return new Promise(resolve => {
    requestAnimationFrame(resolve);
  });
}
