/**
 * Marker visibility checkbox control module.
 */
import type {
  ActionContext,
  ActionTree,
  GetterTree,
  Module,
  MutationTree,
} from 'vuex';
import type { RootState } from '.';

/** Explain State */
export interface CheckState {
  // checked
  checked: string[];
}

/** Default state value */
const state: CheckState = {
  checked: [],
};

// Getters
const getters: GetterTree<CheckState, RootState> = {
  checked: (s): string[] => s.checked,
};

// Mutation
const mutations: MutationTree<CheckState> = {
  set(s, checked: string[]) {
    s.checked = checked;
  },
};

// Action
const actions: ActionTree<CheckState, RootState> = {
  /**
   * set checked items.
   * @param context Vuex Context
   * @param checked checked
   */
  setChecked(context: ActionContext<CheckState, RootState>, checked: string[]) {
    context.commit('set', checked);
  },
};

// VuexStore
const CheckModule: Module<CheckState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default CheckModule;
