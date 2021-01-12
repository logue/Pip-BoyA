/** Electron IPC Renderer Type Definition */
import { IpcRenderer } from 'electron';

declare global {
  interface Window {
    ipcRenderer: IpcRenderer;
  }
}
