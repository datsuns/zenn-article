---
title: "たまに書くならこんな言語(MML for NES編)"
emoji: "🍣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["mml", "MusicMacroLanguage"]
published: false
---

# 結局何やったの？

* ファイルを保存したらNESコンパイルしたmmlファイルを再生できるよー
* https://github.com/datsuns/go-mml
* ↑を使ったvim plugin: https://github.com/datsuns/vim-mml-play


# 事の発端

何かの流れのyoutube散策でたどり着いた動画
https://www.youtube.com/watch?v=c1znEwUbCpc
https://www.youtube.com/watch?v=12K3VYm8vrg

まじか面白そうやん！


# よし、書こう。

というわけで動画に倣って環境設定していきいましょう
* ふむふむまずは[コンパイラ](http://ppmck.web.fc2.com/ppmck.html)をいれて、
* `mck/songs`で`mknsf.bat`ですな。
* あそっか[NSFの再生ツール](https://www.foobar2000.org/download)も入れて、

いけるがなーー！
![play-sample-mml](https://storage.googleapis.com/zenn-user-upload/9d37uh24w0po1hou5q8v3xun9k3d)


# 立ちふさがる、、、壁

* いちいちbat打つのめんどい
* わざわざfoobar立ち上げるのもめんどい

と、思う人もやっぱりいる様で、ファイルを保存したら再生してくれる[mckwatch](http://rophon.music.coocan.jp/mckwatch.htm)というツールを作ってる人がいるみたい。

* `mck/mckw`にツールを配置して、
* \*.mmlファイルをドロップ
* エディタが立ち上がって、、

![play-mml-by-mckwatch](https://storage.googleapis.com/zenn-user-upload/4ict2xncg9m323wk41jptbg17t7a)


・・・うん。悪くない。悪くない、、が。

### ちょとつらい1) 再生の中止は「停止」ボタンを押さないといけない

* tryal & error がやりにくい。
* し、できればエディタで完結したい。。~~悪い癖~~

### ちょとつらい2) 時々「監視」が外れることがある

結局これが一番ネック。
ぱちぱち保存してたらたまに「監視」が外れることがある。

イケてるとき
![observed](https://storage.googleapis.com/zenn-user-upload/hm6t374dya591y87zy5eam4jur3f)
いつの間にか「停止」になっとる・・
![cleared](https://storage.googleapis.com/zenn-user-upload/0w6pksf1pmthowhtktsb7izg0vov)

何回か保存して「あれ？」てなることがあって、これがだんだんストレスになっていきました。。


# 結局、自分で作るんだなぁ。。。

ないなら~~作るしかない~~作ればよいって事でやりたいことを考える。
* vimで開いたmmlファイルで保存、ないしは何らかのコマンドで再生する
* 停止もできる

うむ。いたってシンプル。
nsfファイルは結局waveまで変換して再生することになったけど、それも[Game Music Emu library](http://blargg.8bitalley.com/)というのを使えばなんとかなった。
いんたーねっつすごい。


# 結局、自分で作るんだなぁ。。。

vimでの駆動はjobでよかろう。ということで「再生の停止 == jobの停止」と考えると、ファイル変換～再生まで1-shotなcommandで完結しきる必要がありますね。
やることは、
1. mmlファイルをnsfファイルにコンパイル (by ppmck)
1. nsfファイルをwaveファイルに変換 (by GameMusicEmu Lib)
1. waveファイルを再生

となります。

ここまで決まればあとはgolangでos/execしながらやればOK。
GameMusicEmuがc言語の提供のみだったので、そこはcgoでexeに静的リンクで取り込む形に。



# うよきょくせつのりれき

1. 


# そういえばの話


まず譜面の読み方を勉強しないといけないのであった💀💀💀


# リンク集

* 動画up主さんのチャンネル: https://www.youtube.com/channel/UCvAfPHYrXj0feVxv7cVmOMw
* mck wiki: https://wikiwiki.jp/mck/
* ppmck: http://ppmck.web.fc2.com/ppmck.html
* MCKWATCH: http://rophon.music.coocan.jp/mckwatch.htm
* Game Music Emu library: http://blargg.8bitalley.com/
