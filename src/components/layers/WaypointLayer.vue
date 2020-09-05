<template>
  <vl-layer-vector :z-index="5">
    <vl-feature>
      <vl-geom-point :coordinates="coordinates" />
      <vl-style-box>
        <vl-style-icon
          src="/img/WaypointMarker.svg"
          :img-size="[32, 32]"
          :scale="1"
          cross-origin="anonymous"
        />
      </vl-style-box>
    </vl-feature>
  </vl-layer-vector>
</template>

<script>
export default {
  data() {
    return {
      coordinates: [0, 0],
    };
  },
  mounted() {
    this.coordinates = [this.$route.query.x | 0, this.$route.query.y | 0];
  },
};
</script>
