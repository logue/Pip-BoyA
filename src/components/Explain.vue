<template>
  <v-expand-transition>
    <v-card v-if="category && types && !loading" shaped dark class="explain">
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
          {{ $t('toggleShrink') }}
        </v-tooltip>
      </v-card-title>
      <v-expand-transition>
        <v-card-text v-if="!isShrinked" class="explain_body">
          <ul v-if="colorset[0] !== 'red'" class="explain_list">
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
              >
                <template #label>
                  <v-badge
                    inline
                    :label="type"
                    :content="count(type)"
                    :color="colorset[index]"
                    :class="`explain_list_item_label ${colorset[index]}--text text--lighten-2`"
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
      </v-expand-transition>
    </v-card>
  </v-expand-transition>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { ActionPayload } from 'vuex';
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
  // Checked
  private get checked(): string[] {
    return this.$store.getters['CheckModule/checked'];
  }
  private set checked(checked: string[]) {
    this.$store.dispatch('CheckModule/setChecked', checked);
  }
  // indeterminate Flag
  private get indeterminate(): boolean {
    return (
      this.checked.length !== 0 && this.types.length !== this.checked.length
    );
  }
  // Marker count
  private get count(): { [key: string]: number } {
    return this.$store.getters['CategoryMarkerModule/count'];
  }

  // Mounted
  private mounted() {
    this.$store.subscribeAction((action: ActionPayload) => {
      // Register category changes
      if (action.type === 'CategoryMarkerModule/setCategory') {
        // Reset
        this.types = this.colorset = this.checked = [];
        this.counts = {};

        if (!this.category) {
          return;
        }

        this.types = this.$store.getters['CategoryMarkerModule/types'](
          this.category
        );
        this.colorset = this.$store.getters['CategoryMarkerModule/colorset'](
          this.category
        );
        // マーカーはすべて選択状態にする
        this.checked = this.types;
      }
    });
  }

  /**
   * Toggle Marker visibility by Marker type.
   */
  public toggleMarker(): void {
    // if all checkbox is checked, change checkAll checkbox.
    this.checkAll = this.types.length === this.checked.length;
  }
  /**
   * Toggle CheckAll checkbox/
   */
  public toggleCheckAll(): void {
    if (this.checkAll) {
      // Select all CheckBox
      this.checked = this.types;
    } else {
      // Unselect all ClearBox selected
      this.checked = [];
    }
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
