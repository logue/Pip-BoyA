<template>
  <v-dialog v-model="dialog" max-width="800" @keydown.esc="close">
    <v-card>
      <v-card-title>
        About
        <v-spacer />
        <v-btn icon @click="close">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-card-text>
        <section class="my-2">
          <h2>{{ about }}</h2>
          <nl2br tag="p" :text="description" />
        </section>
        <section class="my-2">
          <h2>Author</h2>
          <v-card width="480">
            <div class="d-flex">
              <v-avatar class="ml-0 mt-0" size="128" tile>
                <v-gavatar email="logue@hotmail.co.jp" :size="128" />
              </v-avatar>
              <div>
                <v-card-title>Logue</v-card-title>
                <v-card-subtitle>Developer</v-card-subtitle>
                <v-card-actions>
                  <v-btn
                    icon
                    color="blue-grey"
                    @click="openLink('http://logue.dev/')"
                  >
                    <v-icon>mdi-home</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="blue"
                    @click="openLink('https://twitter.com/logue256')"
                  >
                    <v-icon>mdi-twitter</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="black"
                    @click="openLink('https://github.com/logue')"
                  >
                    <v-icon>mdi-github</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="indigo"
                    @click="openLink('https://steamcommunity.com/id/logue256/')"
                  >
                    <v-icon>mdi-steam</v-icon>
                  </v-btn>
                </v-card-actions>
              </div>
            </div>
          </v-card>
        </section>
        <section class="my-2">
          <h2>Legal Notice</h2>
          <p>
            Fallout® 76 Wastelanders © 2020 Bethesda Softworks LLC, a ZeniMax
            Media company. Bethesda, Bethesda Softworks, Bethesda Game Studios,
            ZeniMax, Pip-Boy, Vault-Tec and related logos are registered
            trademarks or trademarks of ZeniMax Media Inc. in the U.S. and/or
            other countries. Fallout, Vault Boy and related logos are trademarks
            or registered trademarks of Bethesda Softworks LLC in the U.S.
            and/or other countries. All Rights Reserved.
          </p>
          <p>
            Persistent broadband internet connection required. Acceptance of end
            user license agreement, Terms of Service, and Privacy Policy, and
            account registration required to play. Product may be discontinued,
            and content modified, disabled, suspended or removed, at any time.
            Product requires installation of application software. See Terms of
            Service, Privacy Policy and additional details at bethesda.net.
          </p>
        </section>
        <section class="my-2">
          <h2>Acknowledgement</h2>
          <p>
            <a
              href="https://www.reddit.com/r/fo76/comments/bmwpx9"
              target="_blank"
            >
              Mappalachia: My project which can automatically build maps of
              every resource in the game world.
            </a>
          </p>
        </section>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
import {sprintf} from 'sprintf-js';
import Gravatar from 'vue-gravatar';
import Nl2br from 'vue-nl2br';

export default {
  components: {
    'v-gavatar': Gravatar,
    nl2br: Nl2br,
  },
  data() {
    return {
      dialog: false,
      about: sprintf(this.$t('about'), this.$t('title')),
      description: this.$t('description'),
    };
  },
  methods: {
    open() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    openLink(uri) {
      window.open(uri);
    },
  },
};
</script>
