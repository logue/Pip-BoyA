<template>
  <span>
    <v-dialog v-model="dialog" max-width="600" light @keydown.esc="close">
      <v-card>
        <v-card-title>
          {{ $t('getUri') }}
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="uri" label="URI" readonly />
        </v-card-text>
        <v-card-actions>
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
    <v-snackbar v-model="snackbar" timeout="2000">
      {{ snackbarText }}
      <template #action="{attrs}">
        <v-btn color="blue" text v-bind="attrs" @click="snackbar = false">
          {{ $t('close') }}
        </v-btn>
      </template>
    </v-snackbar>
  </span>
</template>

<script>
import {getUri} from '@/assets/utility.js';
/**
 * Get location uri dialog.
 */
export default {
  data() {
    return {
      dialog: false,
      snackbar: false,
      snackbarText: null,
      uri: null,
    };
  },
  mounted() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type === 'location/setLocation') {
        // URLを更新
        this.uri = getUri(this.$store.state.location, this.$router);
      }
    });
  },
  methods: {
    // ウィンドウを開いたとき
    open() {
      this.dialog = true;
    },
    // ウィンドウを閉じる
    close() {
      this.dialog = false;
    },
    // クリップボードにコピー
    onCopy(e) {
      this.dialog = false;
      this.snackbarText = this.$t('copy-success');
      this.snackbar = true;
    },
    // クリップボードにコピーできなかったとき
    onError(e) {
      this.dialog = false;
      this.snackbarText = this.$t('copy-failure');
      this.snackbar = true;
    },
  },
};
</script>
