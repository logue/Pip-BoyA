/*
 * Electron ipcRenderer Preloader
 */

import { ipcRenderer } from 'electron';
window.ipcRenderer = ipcRenderer;
// const { ipcRenderer } = window.require('electron');
