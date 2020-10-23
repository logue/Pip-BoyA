<template>
  <v-card v-if="category" shaped dark class="explain">
    <v-card-title class="explain_title">
      {{ $t('legend') }}
      <v-spacer />
      <v-checkbox
        v-if="Object.keys(types)[0] !== '0'"
        v-model="checkAll"
        color="gray"
        :title="$t('toggleMarkerSelect')"
        :indeterminate="indeterminate"
        @click="setSelection"
      />
      <v-tooltip top>
        <template #activator="{on, attrs}">
          <v-btn icon v-bind="attrs" @click="toggleShrink" v-on="on">
            <v-icon v-if="!isShrinked">mdi-window-minimize</v-icon>
            <v-icon v-else>mdi-window-maximize</v-icon>
          </v-btn>
        </template>
        <span>{{ $t('toggleShrink') }}</span>
      </v-tooltip>
    </v-card-title>
    <v-card-text v-if="!isShrinked" class="explain_body">
      <ul v-if="Object.keys(types)[0] === '0'" class="explain_list">
        <li
          v-for="(item, index) in types"
          :key="index"
          :class="`explain_list_item explain_list_item_${colorset[index]}`"
        >
          ◆ {{ $t(item) }}
        </li>
      </ul>
      <ul v-else class="explain_list explain_check_list">
        <li
          v-for="(value, key, index) in types"
          :key="index"
          class="explain_list_item explain_list_checkbox"
        >
          <v-checkbox
            v-model="checked"
            :color="colorset[index]"
            :value="key"
            dense
            hide-details
            class="sm"
            @change="toggleMarker"
          >
            <template #label>
              <v-badge
                inline
                :label="key"
                :content="value"
                :color="colorset[index]"
                :class="`explain_list_item_label ${colorset[index]}--text text--lighten-2`"
              >
                {{ $t(`markers.${key}`) }}
              </v-badge>
            </template>
          </v-checkbox>
        </li>
      </ul>
      <!--p v-if="$t('annotations.' + $route.params.category)">
        {{ $t('annotations.' + $route.params.category) }}
      </p-->
    </v-card-text>
  </v-card>
</template>

<script>
/**
 * Explain component
 */
export default {
  emits: ['changed'],
  data() {
    return {
      category: null,
      // 項目
      items: [],
      // 最大化／最小化
      isShrinked: false,
      // チェック済みの項目の配列
      checked: [],
      // 全選択／解除チェックボックスのチェック
      checkAll: true,
      // 全選択／解除チェックボックスの中間状態フラグ
      indeterminate: false,
    };
  },
  computed: {
    types() {
      return this.$store.getters['marker/types'](this.category);
    },
    colorset() {
      return this.$store.getters['marker/colorset'](this.category);
    },
  },
  watch: {
    /**
     * When Page transition
     */
    $route() {
      this.init();
    },
  },
  methods: {
    init() {
      // データ読み込み
      this.category = this.$route.params.category || null;
      // マーカーはすべて選択状態にする
      this.checked = this.items = Object.keys(this.types);
      console.debug('explain init: ', this.category);
    },
    // 最小化／最大化
    toggleShrink() {
      this.isShrinked = !this.isShrinked;
    },
    // マーカー表示／非表示
    toggleMarker() {
      // console.log(this.selected);
      this.checkAll = this.items.length === this.checked.length;
      this.indeterminate =
        this.checked.length !== 0 && this.items.length !== this.checked.length;
      this.$emit('changed', this.checked);
    },
    setSelection(action) {
      if (this.checkAll) {
        // Select all CheckBox
        this.items.forEach((key) => {
          this.checked.push(key);
        }, this);
      } else {
        // Unselect all ClearBox selected
        this.checked = [];
      }
      this.$emit('changed', this.checked);
    },
  },
};
</script>

<style lang="scss">
@import '~vuetify/src/styles/styles.sass';

// アウトライン生成
@function outline($color, $width, $blur) {
  @return $width $width $blur $color, (-$width) $width $blur $color,
    $width (-$width) $blur $color, (-$width) (-$width) $blur $color,
    $width 0px $blur $color, 0px $width $blur $color, (-$width) 0px $blur $color,
    0px (-$width) $blur $color;
}

.explain {
  color: map-get($grey, 'lighten-4');
  text-shadow: outline(map-get($grey, 'darken-4'), 1px, 0.5px);
  position: absolute;
  right: 1rem;
  bottom: 1rem;
  padding: 0.5rem;
  margin: 0;
  z-index: 2;
  &_title {
    padding: 0 0.5rem !important;
  }

  &_body {
    padding: 0;
  }

  .sm {
    &.v-input--selection-controls {
      padding: 0 !important;
      margin: 0 !important;
    }
    .v-input--selection-controls__input {
      margin: 0 !important;
    }
    .v-label,
    .v-icon {
      font-size: 0.75rem !important;
    }
  }
  .v-badge__badge {
    font-size: 0.5rem !important;
  }

  &_list {
    padding-left: 0.5rem !important;
    list-style-type: none;
    column-count: 2;
    &_item {
      font-size: 0.75rem;
      box-sizing: border-box;
      page-break-inside: avoid;
      break-inside: avoid-column;
      .v-input__control {
        display: block;
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
    background-color: rgba(map-get($grey, 'darken-4'), 0.7);
  }
}
</style>
