# Fo76 Pip-Boya Data directory

Files are divided by category and correspond to the map tile directory name in the img/map directory.
カテゴリ別にファイルが分かれており、img/mapディレクトリ内のマップタイルディレクトリ名と対応しています。

Currently, it is only used to define the legend translation key (corresponding to the key of various language files in src/locales), but marker data may be managed here in the future.
現在のところ、凡例の翻訳キー（src/localesの各種言語ファイルのキーと対応）の定義のみに使用していますが、今後マーカーのデーターもここで管理するかもしれません。

## format

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

Put the json key name of the locale in the Explains array.
Explainsの配列には、ロケールのjsonのキー名をいれる。

The color set defines the text color of the legend. Default is the following order.
カラーセットは、凡例の文字色を定義する。デフォルトは以下の順番。
```
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