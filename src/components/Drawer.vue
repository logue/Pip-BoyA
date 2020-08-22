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
    <v-list-item link to="/flora-abundant">
      <v-list-item-action>
        <v-icon>mdi-flower</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.flora') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/flux">
      <v-list-item-action>
        <v-icon>mdi-flask</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.flux') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/encounters">
      <v-list-item-action>
        <v-icon>mdi-alert-decagram</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.encounter') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/headpoint">
      <v-list-item-action>
        <v-icon>mdi-semantic-web</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.headpoint') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/recipe">
      <v-list-item-action>
        <v-icon>mdi-notebook</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.recipe') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/ore">
      <v-list-item-action>
        <v-icon>mdi-cogs</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.ore') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link disabled>
      <v-list-item-action>
        <v-icon>mdi-medical-bag</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.chems') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link disabled>
      <v-list-item-action>
        <v-icon>mdi-food-fork-drink</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.cooking') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/workbench">
      <v-list-item-action>
        <v-icon>mdi-hammer-wrench</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.workbench') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/treasure">
      <v-list-item-action>
        <v-icon>mdi-treasure-chest</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.treasure') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-divider />
    <v-list-item link to="/nuclear-winter">
      <v-list-item-action>
        <v-icon>mdi-nuke</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>Nuclear Winter</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list>
</template>
