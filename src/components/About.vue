<template>
  <v-dialog v-model="dialog" max-width="800" light @keydown.esc="close">
    <v-card>
      <v-card-title>
        About
      </v-card-title>
      <v-card-text>
        <section class="my-2">
          <h2>{{ sprintf(this.$t('about'), this.$t('title')) }}</h2>
          <nl2br tag="p" :text="$t('description')" />
          <v-btn
            href="https://github.com/logue/Pip-BoyA"
            @click.prevent="openNewWin"
          >
            <v-icon left>mdi-github</v-icon>
            Visit Project site
          </v-btn>
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
                    href="http://logue.dev/"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-home</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="blue"
                    href="https://twitter.com/logue256"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-twitter</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="indigo"
                    href="https://facebook.com/logue256"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-facebook</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="gray"
                    href="https://github.com/logue"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-github</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="deep-purple"
                    href="https://steamcommunity.com/id/logue256/"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-steam</v-icon>
                  </v-btn>
                  <v-btn
                    icon
                    color="deep-orange"
                    href="https://www.reddit.com/user/logue256"
                    @click.prevent="openNewWin"
                  >
                    <v-icon>mdi-reddit</v-icon>
                  </v-btn>
                </v-card-actions>
              </div>
            </div>
          </v-card>
        </section>
        <section class="my-2">
          <h2>Acknowledgement</h2>
          <ul>
            <li>
              <a
                href="https://www.reddit.com/r/fo76/comments/bmwpx9"
                @click.prevent="openNewWin"
              >
                Mappalachia
              </a>
              - for some marker.
            </li>
            <li>
              <a
                href="https://github.com/dan-parker/fo76edit-scripts"
                @click.prevent="openNewWin"
              >
                fo76edit-scripts
              </a>
              - for export and convert game data.
            </li>
          </ul>
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
        </section>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn text color="secondary" @click="close">
          <v-icon left>mdi-close</v-icon>
          {{ $t('close') }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
/**
 * About dialog
 */
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
    };
  },
  methods: {
    sprintf(...arr) {
      return sprintf(...arr);
    },
    open() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    openNewWin(e) {
      const href = e.currentTarget.href;
      if (process.env.IS_ELECTRON) {
        this.$electron.shell.openExternal(href);
      } else {
        window.open(href);
      }
      return false;
    },
  },
};
</script>
