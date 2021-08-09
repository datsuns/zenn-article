---
title: "入門Goプログラミング読んだやで"
emoji: "🎶"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["go"]
published: true
---

# 本リンク

[amazon](https://www.amazon.co.jp/%E5%85%A5%E9%96%80Go%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0-Nathan-Youngman-ebook/dp/B07Q23N697)

評価的には賛否両論ぽかったけど翔泳社セールで買った。

* 読んだ途中から書いてるので中身は唐突

# Lesson17 スライス

わかっているようでわかってないスライス

## 結論

* 裏で配列(基底配列)が生成されている
* スライスはあくまで基底配列への参照になっている
* スライスは窓かビューのようなもの。それを**通して配列に注目**する

## メモ

```go
// 配列宣言でのサイズ省略
array := [...]{"Ceres", "Haumea", "Eris"}
```

```go:list17-4_hyperspace.go
package main

import (
	"fmt"
	"strings"
)

func hyperspace(worlds []string) {
	fmt.Printf("%p\n", &worlds)
	// アドレスはplanetsとは別
	// 参照のアドレスが見えているので"そらそうだ"ろう
	for i := range worlds {
		worlds[i] = strings.TrimSpace(worlds[i])
	}
}

func main() {
	planets := []string{" Venus", "Earth ", " Mars"}
	fmt.Printf("%p\n", &planets)

	hyperspace(planets)
	fmt.Println(strings.Join(planets, ""))
}
```

# Lesson18 もっと大きなスライス

## 結論

* 配列は「要素数」を持つ。スライスはあくまで配列への参照。
   * スライスの宣言で暗黙に配列が生成される

## メモ

```go:list18-1_append.go
dwarfs := []string{"Ceres", "Pluto", "Haumea", "Makemake", "Eris"}
dwarfs = append(dwarfs, "Orcus")
// 新たな規定配列を取り直す(可能性がある)のでappend()は
// スライスを受け取ってスライスを返す形になってるのだと思う
```
