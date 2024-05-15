/**
 * Fallout Pip-boy Application (Pip-BoyA／Pip坊や) for Electron
 * @author    Logue <logue@hotmail.co.jp>
 * @version   0.7.0
 * @copyright 2020-2022 Masashi Yoshikawa <https://logue.dev/> All rights reserved.
 * @license   MIT
 */

'use strict';

import { app, protocol, BrowserWindow, ipcMain, Menu } from 'electron';
import { createProtocol } from 'vue-cli-plugin-electron-builder/lib';
import installExtension, { VUEJS_DEVTOOLS } from 'electron-devtools-installer';
import type { IpcMainEvent } from 'electron/main';
const isDevelopment = process.env.NODE_ENV !== 'production';

let win: BrowserWindow;

// Scheme must be registered before the app is ready
protocol.registerSchemesAsPrivileged([
  { scheme: 'app', privileges: { secure: true, standard: true } },
]);

if (app.isPackaged) {
  // Removing the menu bar from the window.
  Menu.setApplicationMenu(null);
}

/**
 *
 */
async function createWindow() {
  // Create the browser window.
  win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      // Use pluginOptions.nodeIntegration, leave this alone
      // See nklayman.github.io/vue-cli-plugin-electron-builder/guide/security.html#node-integration for more info
      nodeIntegration: true,
      contextIsolation: false,
    },
  });

  if (process.env.WEBPACK_DEV_SERVER_URL) {
    // Load the url of the dev server if in development mode
    await win.loadURL(process.env.WEBPACK_DEV_SERVER_URL);
    if (!process.env.IS_TEST) win.webContents.openDevTools();
  } else {
    createProtocol('app');
    // Load the index.html when not in development
    win.loadURL('app://./index.html');
  }
}

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', async () => {
  if (isDevelopment && !process.env.IS_TEST) {
    // Install Vue Devtools
    try {
      await installExtension(VUEJS_DEVTOOLS);
    } catch (e) {
      console.error('Vue Devtools failed to install:', e);
    }
  }
  createWindow();
});

// Exit cleanly on request from parent process in development mode.
if (isDevelopment) {
  if (process.platform === 'win32') {
    process.on('message', data => {
      if (data === 'graceful-exit') {
        app.quit();
      }
    });
  } else {
    process.on('SIGTERM', () => {
      app.quit();
    });
  }
}

// Event handling
// i18n
ipcMain.on('setLocale', (event: IpcMainEvent, locale: string) => {
  app.commandLine.appendSwitch('lang', locale);
  event.returnValue = app.getLocale();
});

// Tray icon progressbar
ipcMain.on('setProgress', (event: IpcMainEvent, value: number) => {
  win.setProgressBar(value * 0.01);
  event.returnValue = value;
});
