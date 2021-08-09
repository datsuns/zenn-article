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

```go:list18-2_slice-dump.go
package main

import "fmt"

func dump(label string, slice []string) {
	fmt.Printf("%v: 長さ %v, 容量 %v %v\n", label, len(slice), cap(slice), slice)
}
func main() {
	dwarfs := []string{"Ceres", "Pluto", "Hauma", "Makemake", "Eris"}
	// dwarfs: 長さ 5, 容量 5 [Ceres Pluto Hauma Makemake Eris]
	dump("dwarfs", dwarfs)
	// dwarfs[1:2]: 長さ 1, 容量 4 [Pluto]
	dump("dwarfs[1:2]", dwarfs[1:2])
}
```

```go:list18-3_slice-append.go
package main

import "fmt"

func dump(label string, slice []string) {
	fmt.Printf("%v: 長さ %v, 容量 %v %v\n", label, len(slice), cap(slice), slice)
}
func main() {
	// dwarfs: 長さ 5, 容量 5 [Ceres Pluto Hauma Makemake Eris]
	dwarfs1 := []string{"Ceres", "Pluto", "Hauma", "Makemake", "Eris"}
	dump("dwarfs1", dwarfs1)

	// dwarfs2: 長さ 6, 容量 10 [Ceres Pluto Hauma Makemake Eris Orcus]
	dwarfs2 := append(dwarfs1, "Orcus")
	dump("dwarfs1", dwarfs1)
	dump("dwarfs2", dwarfs2)

	// dwarfs3: 長さ 9, 容量 10 [Ceres Pluto Hauma Makemake Eris Orcus Salacia Quaor Senda]
	dwarfs3 := append(dwarfs2, "Salacia", "Quaor", "Senda")
	dump("dwarfs1", dwarfs1)
	dump("dwarfs2", dwarfs2)
	dump("dwarfs3", dwarfs3)

	// dwarfs1: 長さ 5, 容量 5 [Ceres Pluto Hauma Makemake Eris]
	// dwarfs2: 長さ 6, 容量 10 [Ceres Pluto! Hauma Makemake Eris Orcus]
	// dwarfs3: 長さ 9, 容量 10 [Ceres Pluto! Hauma Makemake Eris Orcus Salacia Quaor Senda]
	dwarfs3[1] = "Pluto!"
	dump("dwarfs1", dwarfs1)
	dump("dwarfs2", dwarfs2)
	dump("dwarfs3", dwarfs3)
}
```

```go:list18-6_variadic.go
package main

import "fmt"

func terraform(prefix string, worlds ...string) []string {
	ret := make([]string, len(worlds))
	for i := range worlds {
		ret[i] = prefix + " " + worlds[i]
	}
	return ret
}

func main() {
	twoWorlds := terraform("New", "Venus", "Mars")
	fmt.Println(twoWorlds) // [New Venus New Mars]

	planets := []string{"Venus", "Mars", "Jupiter"}
	newPlanets := terraform("New", planets...)
	fmt.Println(newPlanets) // [New Venus New Mars New Jupiter]
}
```
