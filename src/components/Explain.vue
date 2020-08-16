<template>
  <v-card v-if="explains.length !== 0" shaped dark class="explain">
    <v-card-title class="explain_title">
      {{ $t('legend') }}
      <v-spacer />
      <v-btn icon @click="toggleShrink">
        <v-icon v-if="!isShrinked">mdi-window-minimize</v-icon>
        <v-icon v-else>mdi-window-maximize</v-icon>
      </v-btn>
    </v-card-title>
    <v-card-text v-if="!isShrinked" class="explain_body">
      <ul v-if="!isNaN(Number(Object.keys(explains)[0]))" class="explain_list">
        <li
          v-for="(item, index) in explains"
          :key="index"
          :class="`explain_list_item explain_list_item_${colorset.tileExplainColor[index]}`"
        >
          ◆ {{ $t(item) }}
        </li>
      </ul>
      <ul v-else class="explain_list">
        <li
          v-for="(value, item, index) in explains"
          :key="index"
          class="explain_list_item"
        >
          <v-checkbox
            v-model="checked"
            :color="colorset.markerColor[index]"
            :value="item"
            hide-details
            checked
            @change="toggleMarker"
          >
            <template #label>
              <span :class="`${colorset.markerColor[index]}--text`">
                {{ $t(value) }}
              </span>
            </template>
          </v-checkbox>
        </li>
      </ul>
    </v-card-text>
  </v-card>
</template>

<script>
import colorset from '@/assets/colorset.json';

export default {
  props: {
    explains: {
      default: () => {},
      type: Object,
    },
    colors: {
      default: () => [],
      type: Array,
    },
  },
  emits: ['marker-changed'],
  data() {
    return {
      isShrinked: false,
      checked: [],
      markerMode: false,
    };
  },
  mounted() {
    const keys = Object.keys(this.explains);
    this.markerMode = !isNaN(Number(keys[0]));
    if (this.colors.length === 0) {
      // デフォルトのカラー定義
      this.colorset = colorset;
    } else {
      // カラー定義を上書きする場合（タイルモードのみ）
      this.colorset.tileExplainColor = this.colors;
    }
    // デフォルトですべて選択状態
    if (this.markerMode) {
      for (const key in keys) {
        if (Object.prototype.hasOwnProperty.call(keys, key)) {
          this.checked.push(key);
        }
      }
      console.log(this.checked);
    }
  },
  methods: {
    toggleShrink() {
      this.isShrinked = !this.isShrinked;
    },
    toggleMarker() {
      this.$emit('marker-changed');
    },
  },
};
</script>

<style lang="scss">
@import '~vuetify/src/styles/styles.sass';

// アウトライン生成
@function outline($color, $width, $blur) {
  @return $width $width $blur $color, -$width $width $blur $color,
    $width -$width $blur $color, -$width -$width $blur $color,
    $width 0px $blur $color, 0px $width $blur $color, -$width 0px $blur $color,
    0px -$width $blur $color;
}

.explain {
  color: map-get($grey, 'lighten-4');
  text-shadow: outline(rgba(map-get($grey, 'darken-4'), 0.5), 1px, 1px);
  position: absolute;
  right: 1rem;
  bottom: 1rem;
  padding: 0.5rem;
  margin: 0;
  z-index: 100;
  &_title {
    padding: 0 0.5rem !important;
  }

  &_body {
    padding: 0;
  }

  &_list {
    padding-left: 0.5rem !important;
    list-style-type: none;
    columns: 2;
    &_item {
      font-size: 0.75rem;

      .v-input--selection-controls {
        margin: 0;
        padding: 0;
        display: inline-block;
      }
      .v-input--selection-controls__input {
        height: auto;
        width: auto;
      }
      .v-input--selection-controls__ripple {
        height: 1.5rem;
        width: 1.5rem;
        left: -0.75rem;
        top: -0.5rem;
      }

      .v-label,
      .v-icon {
        font-size: 0.75rem !important;
      }

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

      // アウトラインカラーを白にする
      &_green,
      &_red,
      &_blue,
      &_darkgreen,
      &_purple,
      &_maroon {
        text-shadow: outline(rgba(map-get($grey, 'lighten-4'), 0.5), 1px, 1px);
      }
    }
  }
}

.theme--light {
  .explain {
    background-color: rgba(map-get($grey, 'lighten-1'), 0.7);
  }
}

.theme--dark {
  .explain {
    background-color: rgba(map-get($grey, 'darken-3'), 0.7);
  }
}
</style>
