# Extractor Sunrise

Program for extracting missing in [YASSM](https://github.com/dan-parker/fo76edit-scripts).
Be careful because the operation is very heavy.

[Original story](https://fallout.fandom.com/wiki/RobCo_sales_%26_service_center_terminal_entries)

[YASSM](https://github.com/dan-parker/fo76edit-scripts)で不足している抽出プログラム。
とても動作が重いので注意。

[元ネタ](https://game-dictionary.net/fo4/word/%E3%82%A8%E3%82%AD%E3%82%B9%E3%83%88%E3%83%A9%E3%82%AF%E3%82%BF%E3%83%BC%E3%83%BB%E3%82%B5%E3%83%B3%E3%83%A9%E3%82%A4%E3%82%BA)

## Usage

English:

1. Download [Fo76Edit](https://www.nexusmods.com/fallout76/mods/30) and extract it in the Fallout76 directory.
2. Put these *.pas files in Edit Scripts.
3. Launch Fo76Edit, right-click SeventeenSix.esm when loading is complete and select Apply Script.
4. Select the extraction program you just entered and press the OK button.

日本語：

1. [Fo76Edit](https://www.nexusmods.com/fallout76/mods/30)をダウンロードし、Fallout76ディレクトリに展開してください。
2. Edit Scriptsにこれらの*.pasファイルを入れてください。
3. Fo76Editを起動し、ロードが完了したらSeventeenSix.esmを右クリックしてApply Scriptを選択します。
4. 先程入れた抽出プログラムを選択してOKボタンを押してください。

## Notice

It is output as JSON data, but do not think that it can be used as it is by pouring it into a program.
Depending on the output file size, the output file size can reach several megabytes.
Experience shows that if the maximum number of markers that can be displayed on a single map exceeds 300, drawing will be heavy.
When actually configuring a program, I think it is better to divide the data with Excel or use MySQL, sql.js, etc. to obtain the coordinates displayed in the database and limit the markers displayed at one time. I will.

JSONデータとして出力されますが、そのままプログラムに流し込んで使えるとは考えないこと。
ものにもよりますが、出力ファイル容量が数メガに及ぶ場合があります。
経験上単一のマップに300箇所以上マーカーを表示しようとすると描画が重くなります。
実際プログラムを組む場合は、Excelでデータを分割したり、MySQLやsql.jsなどを使用してデータベース化して表示されている座標を取得して一度に表示されるマーカーを制限したほうがいいと思います。

## License

MIT
