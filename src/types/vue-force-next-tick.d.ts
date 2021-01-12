// Vue-force-next tick type definition
// https://github.com/twickstrom/vue-force-next-tick
import VueForceNextTick from 'vue-force-next-tick';

declare module 'vue/types/vue' {
  interface Vue {
    $forceNextTick: typeof VueForceNextTick;
  }
}
