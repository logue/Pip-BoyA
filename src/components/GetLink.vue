<template>
  <v-dialog v-model="dialog" max-width="580" @keydown.esc="close">
    <v-card>
      <v-card-title>
        {{ $t('getUri') }}
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
      <v-card-text>
        <v-text-field :value="uri" label="URI" readonly @click:append="copy">
          <template #append>
            <v-tooltip bottom>
              <template #activator="{ on }">
                <v-btn icon x-small v-on="on" @click="copy()">
                  <v-icon>mdi-content-copy</v-icon>
                </v-btn>
              </template>
              {{ $t('copy') }}
            </v-tooltip>
          </template>
          <template #append-outer>
            <v-btn depressed color="info" v-on="on" @click="go()">
              <v-icon left>mdi-open-in-new</v-icon>
              {{ $t('check') }}
            </v-btn>
          </template>
        </v-text-field>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { copy, openWindow } from '@/helpers/Utility';
/**
 * Get location uri dialog.
 */
@Component
export default class GetLink extends Vue {
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
    openWindow(this.uri);
  }

  /** copy */
  public copy(): void {
    copy(this.uri);
    this.$store.dispatch('setMessage', this.$t('copy-success'));
    this.$forceNextTick();
    this.dialog = false;
  }
}
</script>
