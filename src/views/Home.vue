<template>
  <div class="map-container">
    <map-viewer :category="category" />
    <explain :explains="explains" :colorset="colorset" />
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
    };
  },
  watch: {
    '$route.params.category'() {
      const category = this.$route.params.category;
      if (!category) {
        this.explains = [];
        this.colorset = defaultColorset;
        this.category = null;
        return;
      }
      this.axios.get(`/data/${category}.json`).then((response) => {
        this.explains = response.data.explains;
        this.colorset = response.data.colorset ?? defaultColorset;
      });
      this.category = category;
    },
  },
};
</script>

<style scoped>
.map-container {
  padding: 0;
}
</style>
