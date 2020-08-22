# Fo76 Pip-Boya Data directory

Files are divided by category and correspond to the map tile directory name in the [Map image](../img/map) directory.

Currently, it is only used to define the legend translation key (corresponding to the key of various language files in src/locales), but marker data may be managed here in the future.

カテゴリ別にファイルが分かれており、[マップ画像](../img/map)ディレクトリ内のマップタイルディレクトリ名と対応しています。

現在のところ、凡例の翻訳キー（src/localesの各種言語ファイルのキーと対応）の定義のみに使用していますが、今後マーカーのデーターもここで管理するかもしれません。

## format (marker tile mode)

```json
{
  "explains": [
    "maps.flux.cobalt",
    "maps.flux.fluorescent",
    "maps.flux.violet",
    "maps.flux.crimson",
    "maps.flux.yellowcake"
  ],
  "colorset": [
    "blue",
    "orange",
    "purple",
    "red",
    "yellow"
  ]
}
```

The explains array contains the key names defined in the various [language files](../../src/locales) in the locale directory.

explainsの配列には、[ロケールディレクトリ](../../src/locales)の各種言語ファイルで定義されているキー名をいれる。

The color set defines the text color of the legend. Default is the following order.

カラーセットは、凡例の文字色を定義する。デフォルトは以下の順番。

```js
[
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
]
```

## format (marker location based mode)

markers配列が存在する場合は、マーカー画像レイヤーを使わず、直接ポイントを描画するモードとなります。explain配列のキー名はmarkerの各行のtypeの値と対応しています。
マーカーの座標はFallout76の座標をそのまま使用しているため、他のマップサイトの座標データをそのまま使うことができます。内部的には4096x4096に収まるように座標は縮小されます。

現在のところ、ここにアイコンを使う予定はありません。
