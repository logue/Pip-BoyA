<template>
  <div class="map-container">
    <map-viewer :category="category" />
  </div>
</template>

<script>
export default {
  name: 'Home',
  components: {
    MapViewer: () =>
      import(/* webpackChunkName: "map-viewer" */ '@/components/MapViewer.vue'),
  },
  data() {
    return {
      // 表示カテゴリ
      category: null,
    };
  },
};
</script>
