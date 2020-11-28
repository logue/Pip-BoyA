/**
 * Electron ipcRenderer Preloader
 */
const {ipcRenderer} = require('electron');

process.once('loaded', () => {
  global.native = {
    ipcRenderer: ipcRenderer,
  };
});
