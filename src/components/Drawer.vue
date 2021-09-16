<template>
  <v-list dense>
    <v-list-item link to="/">
      <v-list-item-icon>
        <v-icon>mdi-home</v-icon>
      </v-list-item-icon>
      <v-list-item-content>
        <v-list-item-title v-text="$t('categories.home')" />
      </v-list-item-content>
    </v-list-item>
    <v-divider />
    <div v-for="item in items" :key="item.title">
      <v-list-item v-if="!item.items" :to="item.to" :disabled="!item.to">
        <v-list-item-icon v-if="item.icon">
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title v-text="$t(item.title)" />
        </v-list-item-content>
      </v-list-item>
      <v-list-group
        v-else
        v-model="item.active"
        :prepend-icon="item.icon"
        no-action
      >
        <template #activator>
          <v-list-item-content>
            <v-list-item-title v-text="$t(item.title)" />
          </v-list-item-content>
        </template>

        <v-list-item
          v-for="subItem in item.items"
          :key="subItem.title"
          :to="subItem.to"
          :disabled="!subItem.to"
          link
        >
          <v-list-item-icon v-if="subItem.icon">
            <v-icon>{{ subItem.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title v-text="$t(subItem.title)" />
          </v-list-item-content>
        </v-list-item>
      </v-list-group>
    </div>
  </v-list>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

@Component
export default class Drawer extends Vue {
  readonly items = [
    {
      title: 'categories.flora',
      icon: 'mdi-flower',
      items: [
        {
          title: 'categories.flora-abundant',
          to: '/flora-abundant',
        },
        {
          title: 'categories.flora-fungus',
          to: '/flora-fungus',
        },
        {
          title: 'categories.flora-rare',
          to: '/flora-rare',
        },
        {
          title: 'categories.flora-water',
          to: '/flora-water',
        },
      ],
    },
    {
      title: 'categories.food',
      icon: 'mdi-food-fork-drink',
      items: [
        {
          title: 'categories.food-meat',
          to: null,
        },
        {
          title: 'categories.food-packaged',
          to: '/food-packaged',
        },
        {
          title: 'categories.food-vegitable',
          to: '/food-vegitable',
        },
        {
          title: 'categories.food-misc',
          to: null,
        },
      ],
    },
    {
      icon: 'mdi-flask-round-bottom',
      title: 'categories.flux',
      to: '/flux',
    },
    {
      icon: 'mdi-alert-decagram',
      title: 'categories.encounters',
      items: [
        {
          title: 'categories.encounters-event',
          to: '/encounters-event',
        },
        {
          title: 'categories.encounters-animal',
          to: '/encounters-animal',
        },
        {
          title: 'categories.encounters-bot',
          to: '/encounters-bot',
        },
        {
          title: 'categories.encounters-critter',
          to: '/encounters-critter',
        },
        {
          title: 'categories.encounters-faction',
          to: '/encounters-faction',
        },
        {
          title: 'categories.encounters-insect',
          to: '/encounters-insect',
        },
        {
          title: 'categories.encounters-supermutant',
          to: '/encounters-supermutant',
        },
      ],
    },
    {
      icon: 'mdi-nature-people',
      title: 'categories.denizen',
      to: '/denizen',
    },
    {
      icon: 'mdi-semantic-web',
      title: 'categories.hardpoint',
      to: '/hardpoint',
    },
    {
      icon: 'mdi-notebook',
      title: 'categories.recipe',
      to: '/recipe',
    },
    {
      icon: 'mdi-cogs',
      title: 'categories.ore',
      to: '/ore',
    },
    {
      icon: 'mdi-hammer-wrench',
      title: 'categories.workbench',
      to: '/workbench',
    },
    {
      icon: 'mdi-pharmacy',
      title: 'categories.chems',
      items: [
        {
          title: 'categories.chems-aid',
          to: '/chems-aid',
        },
        {
          title: 'categories.chems-drug',
          to: '/chems-drug',
        },
      ],
    },
    {
      icon: 'mdi-ammunition',
      title: 'categories.ammunition',
      to: null,
    },
    {
      icon: 'mdi-key',
      title: 'categories.safe-terminal',
      to: '/safe-terminal',
    },
    {
      icon: 'mdi-treasure-chest',
      title: 'categories.treasure',
      to: '/treasure',
    },
    {
      icon: 'mdi-alpha-c-circle-outline',
      title: 'categories.caps-pin',
      to: '/caps-pin',
    },
  ];
}
</script>
