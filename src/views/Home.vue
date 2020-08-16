<template>
  <div class="map-container">
    <map-viewer :category="category" :data="data" />
  </div>
</template>

<script>
export default {
  name: 'Home',
  components: {
    MapViewer: () => import('@/components/MapViewer.vue'),
  },
  data() {
    return {
      // 表示カテゴリ
      category: null,
      // レイヤーのデータ
      data: {},
    };
  },
  watch: {
    // カテゴリの値の変化を監視
    '$route.params.category'() {
      this.setCategory();
    },
  },
  mounted() {
    this.setCategory();
  },
  methods: {
    // カテゴリからカテゴリデータを取得
    async setCategory() {
      // ローディングを表示
      this.$root.$data.loading = true;
      // 現在のカテゴリを取得
      this.category = this.$route.params.category;
      if (!this.category) {
        // カテゴリが空白だった場合は凡例とカラーセットを無効化
        this.data = {};
        this.$root.$data.loading = false;
        return null;
      }
      // カテゴリが存在する場合、カテゴリの凡例データの含まれたjsonから凡例の項目とカラーセットを取得
      const response = await this.axios.get(`/data/${this.category}.json`);
      // データ
      this.data = response.data;

      // ローディングを隠す
      this.$root.$data.loading = false;
    },
  },
};
</script>
