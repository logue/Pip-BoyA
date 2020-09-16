/**
 * Map location store
 */
export default {
  namespaced: true,
  state: {
    x: 2048,
    y: -2048,
    z: 1,
  },
  mutations: {
    setLocation(state, {x, y, z}) {
      state.x = x;
      state.y = y;
      state.z = z;
    },
  },
  actions: {
    setLocation(context) {
      context.commit('setLocation');
    },
  },
};
