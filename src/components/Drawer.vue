<template>
  <v-list dense>
    <v-list-item link to="/">
      <v-list-item-action>
        <v-icon>mdi-home</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.home') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-divider />
    <div v-for="item in items" :key="item.title">
      <v-list-item v-if="!item.items" :to="item.to" :disabled="!item.to">
        <v-list-item-action>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ $t(item.title) }}</v-list-item-title>
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
            <v-list-item-title>
              {{ $t(item.title) }}
            </v-list-item-title>
          </v-list-item-content>
        </template>

        <v-list-item
          v-for="subItem in item.items"
          :key="subItem.title"
          :to="subItem.to"
          :disabled="!subItem.to"
          link
        >
          <v-list-item-content>
            <v-list-item-title>{{ $t(subItem.title) }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-group>
    </div>
    <v-divider />
    <v-list-item link to="/nuclear-winter" disabled>
      <v-list-item-action>
        <v-icon>mdi-nuke</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>Nuclear Winter</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list>
</template>

<script>
export default {
  data() {
    return {
      items: [
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
          icon: 'mdi-flask',
          title: 'categories.flux',
          to: '/flux',
        },
        {
          icon: 'mdi-alert-decagram',
          title: 'categories.encounter',
          to: '/encounters',
        },
        {
          icon: 'mdi-semantic-web',
          title: 'categories.headpoint',
          to: '/headpoint',
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
          icon: 'mdi-key',
          title: 'categories.safe-terminal',
          to: '/safe_terminal',
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
      ],
    };
  },
};
</script>
