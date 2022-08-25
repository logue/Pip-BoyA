<template>
  <v-dialog v-if="info" v-model="dialog" max-width="640" @keydown.esc="close">
    <v-card>
      <div class="d-flex">
        <v-avatar
          v-if="
            (info.type && info.name && info.name.match(/^Loc/)) ||
            info.type === 'WaypointMarker'
          "
          size="128"
          tile
          class="m-3"
          :title="info.type"
        >
          <v-img :src="getMarkerIcon(info.type)" />
        </v-avatar>
        <div class="flex-fill">
          <v-card-title v-if="info.name">
            {{ $t(`locations.${info.name}`) }}
            &nbsp;
            <span v-if="info.label" class="grey--text">({{ info.label }})</span>
            <v-spacer />
            <v-btn icon tooltip="close" @click="close">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </v-card-title>
          <v-card-title v-else>
            {{ $t(`markers.${info.type}`) }}
            <span v-if="info.sub">
              <v-icon>mdi-circle-small</v-icon>
              {{ info.sub }}
            </span>
            <span v-if="info.label" class="grey--text">({{ info.label }})</span>
            <v-spacer />
            <v-tooltip top>
              <template #activator="{ on, attrs }">
                <v-btn icon v-bind="attrs" v-on="on" @click="dialog = false">
                  <v-icon>mdi-close</v-icon>
                </v-btn>
              </template>
              {{ $t('close') }}
            </v-tooltip>
          </v-card-title>
          <v-card-subtitle v-if="info.name && $i18n.locale !== 'en'">
            {{ $t(`locations.${info.name}`, 'en') }}
          </v-card-subtitle>
        </div>
      </div>
      <v-card-text>
        <v-simple-table>
          <tbody>
            <tr v-if="info.id">
              <th scope="col">ID</th>
              <td>{{ info.id }}</td>
            </tr>
            <tr v-if="info.name">
              <th scope="col">{{ $t('name') }}</th>
              <td>{{ info.name }}</td>
            </tr>
            <tr v-if="info.type">
              <th scope="col">{{ $t('type') }}</th>
              <td>{{ info.type }}</td>
            </tr>
            <tr>
              <th scope="col">{{ $t('coordinate') }}</th>
              <td>
                {{ info.realX }}, {{ info.realY }}
                <br />
                <small>({{ info.x }}, {{ info.y }})</small>
              </td>
            </tr>
          </tbody>
        </v-simple-table>
      </v-card-text>
      <v-card-actions>
        <v-btn
          v-if="info.name"
          text
          color="green"
          :href="
            'https://fallout.fandom.com/wiki/' +
            encodeURIComponent($t(`locations.${info.name}`, 'en'))
          "
          @click.prevent="openNewWin"
        >
          <v-icon left>mdi-message-cog</v-icon>
          NukaPedia
        </v-btn>
        <v-btn
          v-if="info.name"
          text
          color="blue-grey"
          :href="
            'https://game-dictionary.net/fo76/word/' +
            encodeURIComponent($t(`locations.${info.name}`, 'ja'))
          "
          @click.prevent="openNewWin"
        >
          <v-icon left>mdi-cog-box</v-icon>
          Fallout76大辞典
        </v-btn>
        <v-spacer />
        <v-btn text color="primary" @click="copy()">
          <v-icon left>mdi-clipboard-arrow-down</v-icon>
          {{ $t('copy') }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { copy, openWindow } from '@/helpers/Utility';
import { MarkerProperties } from '@/interfaces/MarkerProperties';

@Component
/**
 * Marker detail window comportent.
 */
export default class MarkerInfo extends Vue {
  /** Marker Infomation dialog visibility */
  dialog = false;

  /** Marker Infomation */
  info: MarkerProperties = {
    id: '0',
    type: undefined,
    name: undefined,
    realX: 0,
    realY: 0,
    x: 0,
    y: 0,
  };

  /** Permalink */
  get uri(): string {
    const uri = this.$router.resolve({
      query: {
        x: (this.info.x | 0).toString(),
        y: (this.info.y | 0).toString(),
      },
    });
    return process.env.IS_ELECTRON
      ? uri.href.replace(/^(?:.+)?#/gm, 'https://fo76.logue.be')
      : location.origin + uri.href;
  }

  /**
   * マーカーアイコンを取得
   *
   * @param type マーカーの種類
   */
  getMarkerIcon(type: string): string {
    return `${process.env.IMAGE_URI || '/img/'}/marker/${type}.svg`;
  }

  open(info: MarkerProperties): void {
    if (!info) {
      return;
    }
    this.info = info;
    this.dialog = true;
  }
  /** Close Dialog */
  close(): void {
    this.dialog = false;
  }
  /** copy */
  copy(): void {
    copy(this.uri);
    this.$store.dispatch('setMessage', this.$t('copy-success'));
  }
  /** Open External Window */
  openNewWin(e: MouseEvent & { currentTarget: HTMLAnchorElement }): boolean {
    openWindow(e.currentTarget.href);
    return false;
  }
}
</script>
