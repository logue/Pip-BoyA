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
  </span>
</template>

<script>
/**
 * Get location uri dialog.
 */
export default {
  data() {
    return {
      dialog: false,
    };
  },
  computed: {
    uri() {
      return this.$store.getters['location/uri'](this.$router);
    },
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
      this.$store.dispatch('setMessage', this.$t('copy-success'));
    },
    // クリップボードにコピーできなかったとき
    onError(e) {
      this.dialog = false;
      this.$store.dispatch('setMessage', this.$t('copy-failure'));
    },
  },
};
</script>
