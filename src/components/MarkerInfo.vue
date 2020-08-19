<template>
  <div>
    <v-dialog v-if="marker" v-model="dialog" max-width="640" light>
      <v-card>
        <div class="d-flex">
          <v-avatar size="128" tile :title="marker.type">
            <v-img :src="`/img/marker/${marker.type}.svg`" width="128" />
          </v-avatar>
          <div>
            <v-card-title>{{ $t(`locations.${marker.name}`) }}</v-card-title>
            <v-card-subtitle v-if="$i18n.locale !== 'en'">
              {{ $t(`locations.${marker.name}`, 'en') }}
            </v-card-subtitle>
            <v-card-text>
              <dl>
                <dt>ID</dt>
                <dd>{{ marker.id }}</dd>
                <dt>Name</dt>
                <dd>{{ marker.name }}</dd>
                <dt>Coordination</dt>
                <dd>[{{ marker.realX }}, {{ marker.realY }}]</dd>
              </dl>
            </v-card-text>
          </div>
        </div>
        <v-card-actions>
          <v-btn
            v-if="marker.name"
            text
            color="green"
            target="_blank"
            :href="
              'https://fallout.fandom.com/wiki/' +
              $t(`locations.${marker.name}`, 'en').replace(/\(.+?\)/, '')
            "
          >
            <v-icon left>mdi-message-cog</v-icon>
            NukaPedia
          </v-btn>
          <v-btn
            v-if="marker.name"
            text
            color="blue-grey"
            target="_blank"
            :href="
              'https://game-dictionary.net/fo76/word/' +
              $t(`locations.${marker.name}`, 'ja').replace(/\（.+?\）/, '')
            "
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
      const url = this.$router.resolve({
        query: {x: this.marker.x, y: this.marker.y, z: 4},
      });
      // this.uri = location.origin + url.href;
      this.uri = 'https://fo76.logue.be' + url.href.replace('#', '');
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
  },
};
</script>
