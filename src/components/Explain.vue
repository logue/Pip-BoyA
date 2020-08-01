<template>
  <v-card v-if="explains.length !== 0" dark class="explain">
    <v-card-title class="explain_title">
      {{ 'legend' }}
      <v-spacer />
      <v-btn icon @click="toggleShrink">
        <v-icon v-if="!isShrink">mdi-window-minimize</v-icon>
        <v-icon v-else>mdi-window-maximize</v-icon>
      </v-btn>
    </v-card-title>
    <v-card-text v-if="!isShrink" class="extplain_body">
      <ul class="explain_list">
        <li
          v-for="(item, index) in explains"
          :key="index"
          :style="`explain_list_color_${colorset[index]}`"
        >
          {{ item }}
        </li>
      </ul>
    </v-card-text>
  </v-card>
</template>

<script>
/** 凡例コンポーネント. */
export default {
  props: {
    // 凡例
    explains: {
      required: false,
      type: Array,
      default: () => [],
    },
    // デフォルトのカラー
    colorset: {
      required: false,
      type: Array,
      default: () => [
        'cyan',
        'magenta',
        'yellow',
        'red',
        'lime',
        'blue',
        'lightgray',
        'orange',
        'springgreen',
        'pink',
        'purple',
        'darkgreen',
        'maroon',
      ],
    },
  },
  data() {
    return {
      isShrink: false,
    };
  },
  methods: {
    toggleShrink() {
      this.isShrink = !this.isShrink;
    },
  },
};
</script>

<style lang="scss">
// 黒のアウトライン
$outline_black: 1px 1px 1px rgba(0, 0, 0, 0.5), -1px 1px 1px rgba(0, 0, 0, 0.5),
  1px -1px 1px rgba(0, 0, 0, 0.5), -1px -1px 1px rgba(0, 0, 0, 0.5),
  1px 0 1px rgba(0, 0, 0, 0.5), 0 1px 1px rgba(0, 0, 0, 0.5),
  -1px 0 1px rgba(0, 0, 0, 0.5), 0 -1px 1px rgba(0, 0, 0, 0.5);
// 白のアウトライン
$outline_white: 1px 1px 1px rgba(255, 255, 255, 0.5),
  -1px 1px 1px rgba(255, 255, 255, 0.5), 1px -1px 1px rgba(255, 255, 255, 0.5),
  -1px -1px 1px rgba(255, 255, 255, 0.5), 1px 0 1px rgba(255, 255, 255, 0.5),
  0 1px 1px rgba(255, 255, 255, 0.5), -1px 0 1px rgba(255, 255, 255, 0.5),
  0 -1px 1px rgba(255, 255, 255, 0.5);

.explain {
  position: absolute !important;
  background-color: rgba(52, 58, 64, 0.75) !important;
  right: 1rem;
  bottom: 1rem;
  padding: 0.5rem;
  margin: 0;
  z-index: 100;
  text-shadow: $outline_black;
  &_title {
    padding: 0 0.5rem !important;
  }

  &_body {
    padding: 0.5rem;
  }

  &_list {
    padding-inline-start: 1rem;
    list-style-type: '♦ ';
    columns: 2;
    &_item {
      font-size: 0.75rem;

      &_cyan {
        color: cyan;
      }
      &_magenta {
        color: magenta;
      }
      &_yellow {
        color: yellow;
      }
      &_red {
        color: red;
      }
      &_lime {
        color: lime;
      }
      &_blue {
        color: blue;
      }
      &_lightgray {
        color: lightgray;
      }
      &_orange {
        color: orange;
      }
      &_springgreen {
        color: springgreen;
      }
      &_pink {
        color: pink;
      }
      &_purple {
        color: purple;
      }
      &_darkgreen {
        color: darkgreen;
      }
      &_maroon {
        color: maroon;
      }

      &_green,
      &_red,
      &_blue,
      &_darkgreen,
      &_purple,
      &_maroon {
        text-shadow: $outline_white;
      }
    }
  }
}
</style>
