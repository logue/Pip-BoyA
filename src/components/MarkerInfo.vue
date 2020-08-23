<template>
  <div>
    <v-dialog
      v-if="marker"
      v-model="dialog"
      max-width="640"
      light
      @keydown.esc="close"
    >
      <v-card>
        <div class="d-flex">
          <v-avatar
            v-if="marker.name && marker.name.match(/^Loc/)"
            size="128"
            tile
            class="m-3"
            :title="marker.type"
          >
            <v-img :src="`/img/marker/${marker.type}.svg`" />
          </v-avatar>
          <div class="flex-fill">
            <v-card-title v-if="marker.name">
              {{ $t(`locations.${marker.name}`) }}
              &nbsp;
              <span v-if="marker.annotation" class="grey--text">
                ( {{ marker.annotation }})
              </span>
            </v-card-title>
            <v-card-subtitle v-if="marker.name && $i18n.locale !== 'en'">
              {{ $t(`locations.${marker.name}`, 'en') }}
            </v-card-subtitle>
            <v-card-text>
              <v-simple-table>
                <tbody>
                  <tr>
                    <th scope="col">ID</th>
                    <td>{{ marker.id }}</td>
                  </tr>
                  <tr v-if="marker.name">
                    <th scope="col">Name</th>
                    <td>{{ marker.name }}</td>
                  </tr>
                  <tr v-if="marker.type">
                    <th scope="col">Type</th>
                    <td>{{ marker.type }}</td>
                  </tr>
                  <tr>
                    <th scope="col">Coordination</th>
                    <td>
                      {{ marker.realX }}, {{ marker.realY }}
                      <small>({{ marker.x }}, {{ marker.y }})</small>
                    </td>
                  </tr>
                </tbody>
              </v-simple-table>
            </v-card-text>
          </div>
        </div>
        <v-card-actions>
          <v-btn
            v-if="marker.name"
            text
            color="green"
            :href="
              'https://fallout.fandom.com/wiki/' +
              $t(`locations.${marker.name}`, 'en')
            "
            @click.prevent="openNewWin"
          >
            <v-icon left>mdi-message-cog</v-icon>
            NukaPedia
          </v-btn>
          <v-btn
            v-if="marker.name"
            text
            color="blue-grey"
            :href="
              'https://game-dictionary.net/fo76/word/' +
              $t(`locations.${marker.name}`, 'ja')
            "
            @click.prevent="openNewWin"
          >
            <v-icon left>mdi-cog-box</v-icon>
            Fallout76大辞典
          </v-btn>
          <v-spacer />
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
          <v-btn text color="secondary" @click="close">
            <v-icon left>mdi-close</v-icon>
            {{ $t('close') }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-snackbar v-model="snackbar" timeout="2000">
      {{ snackbarText }}
      <template #action="{attrs}">
        <v-btn color="blue" text v-bind="attrs" @click="snackbar = false">
          {{ $t('close') }}
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script>
import {getUri} from '@/assets/utility.js';

/**
 * Marker detail window comportent.
 */
export default {
  data() {
    return {
      dialog: false,
      snackbar: false,
      snackbarText: null,
      uri: null,
      marker: {
        id: 0,
        type: null,
        name: null,
        realX: 0,
        realY: 0,
        x: 0,
        y: 0,
      },
    };
  },
  methods: {
    open(marker) {
      this.marker = marker;
      this.uri = getUri(
        {x: this.marker.x, y: this.marker.y, z: 4},
        this.$router
      );
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    onCopy(e) {
      this.dialog = false;
      this.snackbarText = this.$t('copy-success');
      this.snackbar = true;
    },
    onError(e) {
      this.dialog = false;
      this.snackbarText = this.$t('copy-failure');
      this.snackbar = true;
    },
    openNewWin(e) {
      // TODO: ディレクティブで指定できるように

      // 現在のリンクを取得
      const href = e.currentTarget.href;
      if (process.env.IS_ELECTRON) {
        // Electronの場合ブラウザを起動して開く
        this.$electron.shell.openExternal(href);
      } else {
        // ブラウザの場合、通常の新しい画面
        window.open(href);
      }
      return false;
    },
  },
};
</script>
