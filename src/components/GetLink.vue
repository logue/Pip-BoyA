<template>
  <span>
    <v-dialog v-model="dialog" max-width="600" light @keydown.esc="close">
      <v-card>
        <v-card-title>
          {{ $t('getUri') }}
        </v-card-title>
        <v-card-text>
          <v-text-field :value="uri" label="URI" readonly />
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn text color="secondary" @click="dialog = false">
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

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
/**
 * Get location uri dialog.
 */
@Component
export default class GetLink extends Vue {
  /** Dialog visibility */
  private dialog = false;

  private get uri(): string {
    return this.$store.getters['MapLocationModule/uri'](this.$router);
  }

  /** dialog open */
  public open(): void {
    this.dialog = true;
  }
  /** dialog close */
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
}
</script>
