<template>
  <span>
    <v-dialog v-model="dialog" max-width="580" light @keydown.esc="close">
      <v-card>
        <v-card-title>
          {{ $t('getUri') }}
        </v-card-title>
        <v-card-text>
          <v-text-field :value="uri" label="URI" readonly />
        </v-card-text>
        <v-card-actions>
          <v-btn text color="info" @click="go">
            <v-icon left>mdi-open-in-new</v-icon>
            {{ $t('check') }}
          </v-btn>
          <v-spacer />
          <v-btn text color="secondary" @click="dialog = false">
            <v-icon left>mdi-close</v-icon>
            {{ $t('close') }}
          </v-btn>
          <v-btn text color="primary" @click="copy()">
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
import { openWindow } from '@/assets/Utility';
/**
 * Get location uri dialog.
 */
@Component
export default class GetLink extends Vue {
  /** is electron */
  private isElectron = process.env.IS_ELECTRON ?? false;

  /** Dialog visibility */
  private dialog = false;

  /** current location uri */
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
  /** Link to current location */
  public go(): void {
    openWindow(this.uri, this);
  }

  /** copy */
  public copy(): void {
    if (this.isElectron) {
      this.$electron.clipboard.writeText(this.uri);
    } else {
      navigator.clipboard.writeText(this.uri);
    }
    this.dialog = false;
    this.$store.dispatch('setMessage', this.$t('copy-success'));
  }
}
</script>
