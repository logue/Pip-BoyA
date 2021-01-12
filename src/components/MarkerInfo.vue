<template>
  <div>
    <v-dialog
      v-if="info"
      v-model="dialog"
      max-width="640"
      light
      @keydown.esc="close"
    >
      <v-card>
        <div class="d-flex">
          <v-avatar
            v-if="
              (info.name && info.name.match(/^Loc/)) ||
                info.type === 'WaypointMarker'
            "
            size="128"
            tile
            class="m-3"
            :title="info.type"
          >
            <v-img :src="`/img/marker/${info.type}.svg`" />
          </v-avatar>
          <div class="flex-fill">
            <v-card-title v-if="info.name">
              {{ $t(`locations.${info.name}`) }}
              &nbsp;
              <span v-if="info.label" class="grey--text">
                ({{ info.label }})
              </span>
            </v-card-title>
            <v-card-title v-else>
              {{ $t(`markers.${info.type}`) }}
              <span v-if="info.sub">&nbsp;-&nbsp;{{ info.sub }}</span>
              <span v-if="info.label" class="grey--text">
                ({{ info.label }})
              </span>
            </v-card-title>
            <v-card-subtitle v-if="info.name && $i18n.locale !== 'en'">
              {{ $t(`locations.${info.name}`, 'en') }}
            </v-card-subtitle>
            <v-card-text>
              <v-simple-table>
                <tbody>
                  <tr v-if="info.id">
                    <th scope="col">ID</th>
                    <td>{{ info.id }}</td>
                  </tr>
                  <tr v-if="info.name">
                    <th scope="col">Name</th>
                    <td>{{ info.name }}</td>
                  </tr>
                  <tr v-if="info.type">
                    <th scope="col">Type</th>
                    <td>{{ info.type }}</td>
                  </tr>
                  <tr>
                    <th scope="col">{{ $t('coordinate') }}</th>
                    <td>
                      {{ info.realX }}, {{ info.realY }}
                      <small>({{ info.x }}, {{ info.y }})</small>
                    </td>
                  </tr>
                </tbody>
              </v-simple-table>
            </v-card-text>
          </div>
        </div>
        <v-card-actions>
          <v-btn
            v-if="info.name"
            text
            color="green"
            :href="
              'https://fallout.fandom.com/wiki/' +
                $t(`locations.${info.name}`, 'en')
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
                $t(`locations.${info.name}`, 'ja')
            "
            @click.prevent="openNewWin"
          >
            <v-icon left>mdi-cog-box</v-icon>
            Fallout76大辞典
          </v-btn>
          <v-spacer />
          <v-btn text color="secondary" @click="close">
            <v-icon left>mdi-close</v-icon>
            {{ $t('close') }}
          </v-btn>
          <v-btn
            v-clipboard:copy="uri"
            v-clipboard:success="onCopy"
            v-clipboard:error="onError"
            text
            color="primary"
          >
            <v-icon left>mdi-clipboard-arrow-down</v-icon>
            {{ $t('copy') }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { getUri, openWindow } from '@/assets/Utility';
import { MarkerProperties } from '@/types/markerData';

/**
 * Marker detail window comportent.
 */
@Component
export default class MarkerInfo extends Vue {
  /** Marker Infomation dialog visibility */
  private dialog = false;

  /** Marker Infomation */
  private info: MarkerProperties = {
    id: '0',
    type: undefined,
    name: undefined,
    realX: 0,
    realY: 0,
    x: 0,
    y: 0,
  };

  /** Permalink */
  private uri: string | null = null;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/explicit-module-boundary-types
  public open(feature: any): void {
    if (!feature) {
      return;
    }
    this.info = feature.values_;
    this.uri = getUri({ x: this.info.x, y: this.info.y, z: 4 }, this.$router);
    this.dialog = true;
  }
  /** Close Dialog */
  public close(): void {
    this.dialog = false;
  }
  /** When Copy to clipboard */
  public onCopy(): void {
    this.dialog = false;
    this.$store.dispatch('setMessage', this.$t('copy-success'));
  }
  /** When Failure to copy clipboard */
  public onError(): void {
    this.dialog = false;
    this.$store.dispatch('setMessage', this.$t('copy-failure'));
  }
  /** Open External Window */
  public openNewWin(
    e: MouseEvent & { currentTarget: HTMLAnchorElement }
  ): boolean {
    openWindow(e.currentTarget.href, this);
    return false;
  }
}
</script>
