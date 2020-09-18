# Fo76 Pip-Boya Data directory

Files are divided by category and correspond to the map tile directory name in the [Map image](../img/map) directory.

カテゴリ別にファイルが分かれており、[マップ画像](../img/map)ディレクトリ内のマップタイルディレクトリ名と対応しています。

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
  ],
  "markers": [
    {
      "id": "0038B1D7",
      "type": "AshTreasureMarker",
      "x": -101486.8828,
      "y": -81483.96094,
      "label": 2
    },
    ...
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

markers配列が存在する場合は、マーカー画像レイヤーを使わず、ポイントを描画するモードとなります。explain配列のキー名はmarkerの各行のtypeの値と対応しています。
マーカーの座標はFallout76の座標をそのまま使用しているため、他のマップサイトの座標データをそのまま使うことができます。内部的には4096x4096の座標に収まるように座標系は縮小されます。

If the markers array exists, the mode will be used to draw points without using the marker image layer. The key name in the explain array corresponds to the type value in each line of marker.
Since the coordinates of the marker use the coordinates of Fallout76 as they are, the coordinate data of other map sites can be used as they are. Internally the coordinate system is reduced to fit in the 4096x4096 coordinate.

現在のところ、ここにアイコンを使う予定はありません。

Currently there are no plans to use icons here.

マーカーのデータ形式は以下のようになります。labelは任意です。

The data format of the marker is as follows. label is optional.
```
{
  "id": "0038B1D7",
  "type": "AshTreasureMarker",
  "x": -101486.8828,
  "y": -81483.96094,
  "label": 2
},
```

labelに値がある場合マーカーに記載されます。（2文字以上は無視されます）この例の場合、「②」のように表記されます。

If the label has a value, it will be displayed on the marker. (Two or more characters are ignored.) In this example, it is wr9itten as "②".

一つのカテゴリで使用できるマーカーの種類は、[Material Color](https://material.io/resources/color/)で定義されている色と対応しており、19個まで使えます。
それ以上の種類のマーカーを読み込ませた場合は例外が出力されます。

The types of markers that can be used in one category correspond to the colors defined in [Material Color](https://material.io/resources/color/), and up to 17 markers can be used.
An exception will be output if you load more types of markers.

### Nuclear Winter

Nucler Winterのマップの座標系は通常のマップと同じです。単純に通常のマップに投影した場合、40％の大きさと一致します。