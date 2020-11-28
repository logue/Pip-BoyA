import axios from 'axios';
import colors from 'vuetify/lib/util/colors';
import {Style, Icon, Text, Fill, Stroke} from 'ol/style';
import {convertGeoJson} from '@/assets/utility.js';

/**
 * Map location Marker store
 */
export default {
  namespaced: true,
  state: {
    // Marker location object
    features: [],
    // Marker Style definition.
    styles: {},
  },
  getters: {
    features: (state) => state.features,
    styles: (state) => state.styles,
    style: (state) => (type) => state.styles[type],
  },
  mutations: {
    /**
     * save location data to state.
     * @param {Vuex.State} state Vuex State
     * @param {Array} features data
     */
    setFeatures(state, features) {
      state.features = convertGeoJson(features);
    },
    /**
     * save style to state.
     * @param {Vuex.Store} state Vuex State
     * @param {Array} types data
     */
    setStyles(state, types) {
      const styles = {};
      // スタイル定義をキャッシュする
      for (const type of types) {
        styles[type] = new Style({
          // アイコン
          image: new Icon({
            anchor: [0.5, type === 'WaypointMarker' ? 0.9 : 0.5],
            anchorXUnits: 'fraction',
            anchorYUnits: 'fraction',
            crossOrigin: 'anonymous',
            opacity: 1,
            src: `/img/marker/${type}.svg`,
          }),
          // 注釈テキスト
          text: new Text({
            font: 'Noto Sans JP',
            offsetX: 2,
            offsetY: 2,
            // 文字色
            fill: new Fill({
              color: colors.blueGrey.darken4,
            }),
            // 文字のアウトラインの設定
            stroke: new Stroke({
              color: colors.blueGrey.lighten5,
              width: 1,
            }),
          }),
        });
      }
      state.styles = Object.freeze(styles);
    },
  },
  actions: {
    /**
     * Set location data.
     * @param {Vuex.State} context Context
     */
    async init(context) {
      const data = await axios
        .get('/data/locations.json')
        .then((ret) => ret.data)
        .catch((err) => console.error(err));

      // convert Fo76 marker location to geo json object
      context.commit('setFeatures', data.markers);

      // Get marker types.
      context.commit(
        'setStyles',
        Array.from(new Set(data.markers.map((item) => item.type))).sort()
      );
    },
  },
};
