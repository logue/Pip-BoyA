<template>
  <div class="map-container">
    <map-viewer />
    <explain :explains="explains" />
  </div>
</template>

<script>
// @ is an alias to /src
import MapViewer from '@/components/MapViewer.vue';
import Explain from '@/components/Explain.vue';

export default {
  name: 'Home',
  components: {
    MapViewer,
    Explain,
  },
};
</script>

<style scoped>
.map-container {
  padding: 0;
}
</style>
