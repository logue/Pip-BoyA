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
    <v-list-item link to="/encounter">
      <v-list-item-action>
        <v-icon>mdi-alert-decagram</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.encounter') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/resource">
      <v-list-item-action>
        <v-icon>mdi-semantic-web</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.resource') }}</v-list-item-title>
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
    <v-list-item link to="/ole">
      <v-list-item-action>
        <v-icon>mdi-cogs</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.ole') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/chemical">
      <v-list-item-action>
        <v-icon>mdi-medical-bag</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.chems') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item link to="/cooking">
      <v-list-item-action>
        <v-icon>mdi-food-fork-drink</v-icon>
      </v-list-item-action>
      <v-list-item-content>
        <v-list-item-title>{{ $t('categories.cooking') }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list>
</template>
