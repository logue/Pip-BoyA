<template>
  <div class="map-container">
    <map-viewer :category="category" />
    <explain :explains="explains" :colorset="colorset" />
    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </div>
</template>

<script>
// @ is an alias to /src
import MapViewer from '@/components/MapViewer.vue';
import Explain from '@/components/Explain.vue';

const defaultColorset = [
  'cyan',
  'magenta',
  'yellow',
  'red',
  'lime',
  'blue',
  'lightgray',
  'orange',
  'springgreen',
  'pink',
  'purple',
  'darkgreen',
  'maroon',
];
export default {
  name: 'Home',
  components: {
    MapViewer,
    Explain,
  },
  data() {
    return {
      category: null,
      explains: [],
      colorset: defaultColorset,
      loading: false,
    };
  },
  watch: {
    '$route.params.category'() {
      this.loading = true;
      const category = this.$route.params.category;
      if (!category) {
        this.explains = [];
        this.colorset = defaultColorset;
        this.category = null;
        this.loading = false;
        return;
      }
      this.axios.get(`/data/${category}.json`).then((response) => {
        this.explains = response.data.explains;
        this.colorset = response.data.colorset ?? defaultColorset;
      });
      this.category = category;
      this.loading = false;
    },
  },
};
</script>

<style scoped>
.map-container {
  padding: 0;
  width: 100%;
  height: 100%;
}
</style>
