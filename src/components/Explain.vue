<template>
  <v-expand-transition>
    <v-card v-if="category && types.length !== 0" shaped dark class="explain">
      <v-card-title class="explain_title">
        {{ $t('legend') }}
        <v-spacer />
        <v-checkbox
          v-if="!isShrinked && counts"
          v-model="checkAll"
          color="gray"
          :title="$t('toggleMarkerSelect')"
          :indeterminate="indeterminate"
          @click="toggleCheckAll"
        />
        <v-tooltip top>
          <template #activator="{ on, attrs }">
            <v-btn
              icon
              v-bind="attrs"
              @click="isShrinked = !isShrinked"
              v-on="on"
            >
              <v-icon v-if="!isShrinked">mdi-window-minimize</v-icon>
              <v-icon v-else>mdi-window-maximize</v-icon>
            </v-btn>
          </template>
          <span>{{ $t('toggleShrink') }}</span>
        </v-tooltip>
      </v-card-title>
      <v-scale-transition>
        <v-card-text v-if="!isShrinked" class="explain_body">
          <ul v-if="!counts" class="explain_list">
            <li
              v-for="(type, index) in types"
              :key="index"
              :class="`explain_list_item explain_list_item_${colorset[index]}`"
            >
              ◆ {{ $t(type) }}
            </li>
          </ul>
          <ul v-else class="explain_list explain_check_list">
            <li
              v-for="(type, index) in types"
              :key="index"
              class="explain_list_item explain_list_checkbox"
            >
              <v-checkbox
                v-model="checked"
                :color="colorset[index]"
                :value="type"
                dense
                hide-details
                class="sm"
                @change="toggleMarker"
              >
                <template #label>
                  <v-badge
                    inline
                    :label="type"
                    :content="counts[type]"
                    :color="colorset[index]"
                    :class="
                      `explain_list_item_label ${colorset[index]}--text text--lighten-2`
                    "
                  >
                    {{ $t(`markers.${type}`) }}
                  </v-badge>
                </template>
              </v-checkbox>
            </li>
          </ul>
          <!--p v-if="$t('annotations.' + $route.params.category)">
        {{ $t('annotations.' + $route.params.category) }}
      </p-->
        </v-card-text>
      </v-scale-transition>
    </v-card>
  </v-expand-transition>
</template>

<script lang="ts">
import { Component, Emit, Vue, Watch } from 'vue-property-decorator';
/**
 * Explain component
 */
@Component
export default class Explain extends Vue {
  // marker type and count
  private types: string[] = [];
  // marker types
  private counts: { [key: string]: number } = {};
  // marker color
  private colorset: string[] = [];
  // Maximize/Minimize
  private isShrinked = false;
  // Checked Marker
  private checked: string[] = [];
  // Check All/Uncheck all
  private checkAll = true;
  // Check loading
  private get loading(): boolean {
    return this.$store.getters.loading;
  }
  // current category
  private get category(): string {
    return this.$route.params.category;
  }
  // indeterminate Flag
  private get indeterminate(): boolean {
    return (
      this.checked.length !== 0 && this.types.length !== this.checked.length
    );
  }
  /**
   * Category
   */
  @Watch('loading')
  private onLoading(): void {
    // Reset
    // this.types = this.colorset = this.checked = [];
    // this.counts = {};

    if (!this.category) {
      return;
    }

    this.types = this.$store.getters['CategoryMarkerModule/types'](
      this.category
    );
    this.counts = this.$store.getters['CategoryMarkerModule/counts'](
      this.category
    );
    this.colorset = this.$store.getters['CategoryMarkerModule/colorset'](
      this.category
    );
    // マーカーはすべて選択状態にする
    this.checked = this.types;

    console.debug('explain ready: ', this.category, this.counts);
  }
  /**
   * Toggle Marker visibility by Marker type.
   */
  @Emit('changed')
  public toggleMarker(): void {
    // if all checkbox is checked, change checkAll checkbox.
    this.checkAll = this.types.length === this.checked.length;
    this.$emit('changed', this.checked);
  }
  /**
   * Toggle CheckAll checkbox/
   */
  @Emit('changed')
  public toggleCheckAll(): void {
    if (this.checkAll) {
      // Select all CheckBox
      this.types.forEach((key: string) => {
        this.checked.push(key);
      }, this);
    } else {
      // Unselect all ClearBox selected
      this.checked = [];
    }
    this.$emit('changed', this.checked);
  }
}
</script>

<style lang="scss">
@import '~vuetify/src/styles/styles.sass';

// アウトライン生成
@function outline($color, $width, $blur) {
  @return $width $width $blur $color, (-$width) $width $blur $color,
    $width (-$width) $blur $color, (-$width) (-$width) $blur $color,
    $width 0 $blur $color, 0 $width $blur $color, (-$width) 0 $blur $color,
    0 (-$width) $blur $color;
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
