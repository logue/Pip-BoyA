<template>
  <v-dialog v-model="dialog" max-width="640" light>
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
            ID: {{ marker.id }}
            <br />
            Real Location:[{{ marker.x }}, {{ marker.y }}]
          </v-card-text>
        </div>
      </div>
      <v-card-actions>
        <v-spacer />
        <v-btn
          text
          color="green"
          target="_blank"
          :href="
            'https://fallout.fandom.com/wiki/' +
            $t(`locations.${marker.name}`, 'en')
          "
        >
          <v-icon left>mdi-message-cog</v-icon>
          NukaPedia
        </v-btn>
        <v-btn
          text
          color="blue-grey"
          target="_blank"
          :href="
            'https://game-dictionary.net/fo76/word/' +
            $t(`locations.${marker.name}`, 'ja')
          "
        >
          <v-icon left>mdi-cog-box</v-icon>
          Fallout76大辞典
        </v-btn>
        <v-btn text color="secondary" @click="close">
          <v-icon left>mdi-close</v-icon>
          {{ $t('close') }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    marker: {
      type: Object,
      default: () => {
        return {
          id: null,
          type: null,
          name: null,
          x: 0,
          y: 0,
        };
      },
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  methods: {
    open() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
  },
};
</script>
