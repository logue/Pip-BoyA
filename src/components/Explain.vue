<template>
  <v-card v-if="explains" shaped dark class="explain">
    <v-card-title class="explain_title">
      {{ $t('legend') }}
      <v-spacer />
      <v-btn icon @click="toggleShrink">
        <v-icon v-if="!isShrinked">mdi-window-minimize</v-icon>
        <v-icon v-else>mdi-window-maximize</v-icon>
      </v-btn>
    </v-card-title>
    <v-card-text v-if="!isShrinked" class="explain_body">
      <ul v-if="explains[0].match(/^map/)" class="explain_list">
        <li
          v-for="(item, index) in explains"
          :key="index"
          :class="`explain_list_item explain_list_item_${set.tileExplainColor[index]}`"
        >
          ◆ {{ $t(item) }}
        </li>
      </ul>
      <ul v-else class="explain_list explain_check_list">
        <li
          v-for="(item, index) in explains"
          :key="index"
          class="explain_list_item explain_list_checkbox"
        >
          <v-checkbox
            v-model="checked"
            :color="set.markerColor[getColorIndex(index)]"
            :value="item"
            hide-details
            checked="true"
            @change="toggleMarker"
          >
            <template #label>
              <span
                :class="`explain_list_item_label ${
                  set.markerColor[getColorIndex(index)]
                }--text`"
              >
                {{ $t(`markers.${item}`) }}
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
/**
 * Explain component
 */
export default {
  emits: ['select-change'],
  data() {
    return {
      // カラーセット
      set: colorset,
      // 凡例
      explains: {},
      // 色設定
      colors: [],
      // 最大化／最小化
      isShrinked: false,
      // チェック済みの項目の配列
      checked: [],
      // falseは画像マーカーモード
      markerMode: false,
    };
  },
  methods: {
    update(explains) {
      this.explains = explains;
      // マーカーはすべて選択状態にする
      this.checked = explains;
    },
    // 最小化／最大化
    toggleShrink() {
      this.isShrinked = !this.isShrinked;
    },
    // マーカー表示／非表示
    toggleMarker() {
      // console.log(this.checked);
      this.$emit('select-change', this.checked);
    },
    getColorIndex(index) {
      if (this.set.markerColor.length / this.explains.length > 2) {
        // マーカーの種類が少ない場合、色がバラけるようにする。
        index =
          (index * (this.set.markerColor.length / this.explains.length)) | 0;
      }
      return index;
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
      &_label {
        text-shadow: outline(rgb(0, 0, 0), 0px, 1px);
      }

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
