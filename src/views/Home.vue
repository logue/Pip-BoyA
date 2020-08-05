<template>
  <div class="map-container">
    <map-viewer
      :category="category"
      :explains="explains"
      :colorset="colorset"
    />
  </div>
</template>

<script>
// @ is an alias to /src
import MapViewer from '@/components/MapViewer.vue';

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
  },
  data() {
    return {
      // 表示カテゴリ
      category: null,
      // 凡例
      explains: [],
      // 凡例のカラーセット
      colorset: [],
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
    // カテゴリから凡例とカラーセットを取得
    async setCategory() {
      // ローディングを表示
      this.$root.$data.loading = true;
      // 現在のカテゴリを取得
      this.category = this.$route.params.category;
      if (!this.category) {
        // カテゴリが空白だった場合は凡例とカラーセットを無効化
        this.explains = [];
        this.colorset = [];
        this.$root.$data.loading = false;
        return null;
      }
      // カテゴリが存在する場合、カテゴリの凡例データの含まれたjsonから凡例の項目とカラーセットを取得
      const response = await this.axios.get(`/data/${this.category}.json`);
      // 凡例
      this.explains = response.data.explains;
      // カラーセット
      this.colorset = response.data.colorset ?? defaultColorset;

      // TODO: マーカー
      // ローディングを隠す
      this.$root.$data.loading = false;
    },
  },
};
</script>
