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

# Lesson19 守備範囲が広いマップ

## 結論

## メモ

* "マップ"って、「写像」らしい
* キーの順序に保証はない(実行するたびに変わるかもしれない)

```go:list19-1_map.go
package main

import "fmt"

func main() {
	temperature := map[string]int{
		"Earch": 15,
		"Mars":  -65,
	}

	temp := temperature["Earch"]
	fmt.Printf("平均すると、地球は%v℃.\n", temp)

	temperature["Earch"] = 16
	temperature["Venus"] = 464
	fmt.Println(temperature) // map[Earch:16 Mars:-65 Venus:464]
	moon := temperature["Moon"]
	fmt.Println(moon) // 0

	if moon2, ok := temperature["Moon"]; ok {
		fmt.Printf("平均すると、月は%v℃.\n", moon2)
	} else {
		fmt.Println("月はどこ？") // reach to here
	}
}
```

```go:list19-2_whoops.go
package main

import "fmt"

func main() {
	planets := map[string]string{
		"地球": "Sector ZZ9",
		"火星": "Sector ZZ9",
	}

	planetsMarkII := planets
	planets["地球"] = "whoops"
	fmt.Println(planets)       // map[地球:whoops 火星:Sector ZZ9]
	fmt.Println(planetsMarkII) // map[地球:whoops 火星:Sector ZZ9]

	delete(planets, "地球")
	fmt.Println(planets)       // map[火星:Sector ZZ9]
	fmt.Println(planetsMarkII) // map[火星:Sector ZZ9]
}
```

```go:list19-3_frequency.go
package main

import "fmt"

func main() {
	temperatures := []float64{
		-28.0, 32.0, -31.0, -29.0, -23.0, -29.0, -28.0, -33.0,
	}

	frequency := make(map[float64]int)

	for _, t := range temperatures {
		frequency[t]++
	}

	for t, n := range frequency {
		fmt.Printf("%+.2fの出現回数は%d回です\n", t, n)
		// -28.00の出現回数は2回です
		// +32.00の出現回数は1回です
		// -31.00の出現回数は1回です
		// -29.00の出現回数は2回です
		// -23.00の出現回数は1回です
		// -33.00の出現回数は1回です
	}
}

```

```go:list19-4_group.go
package main

import (
	"fmt"
	"math"
)

func main() {
	temperatures := []float64{
		-28.0, 32.0, -31.0, -29.0, -23.0, -29.0, -28.0, -33.0,
	}

	groups := make(map[float64][]float64)

	for _, t := range temperatures {
		g := math.Trunc(t/10) * 10
		groups[g] = append(groups[g], t)
	}

	for g, temperatures := range groups {
		fmt.Printf("%v: %v\n", g, temperatures)
	}
}
```

```go:training2_words.go
package main

import (
	"fmt"
	"strings"
)

var InputText = `
As far as eye could reach he saw nothing but the stems of the great plants
about him receding in the violet shade, and far overhead the multiple transparencey
of huge leaves filtering the sunshine to the solemn splendour of twilight in which
he walked.
`

func main() {
	fmt.Printf("[%v]\n", InputText)
	lower := strings.ToLower(InputText)
	rawText := strings.ReplaceAll(strings.ReplaceAll(lower, ",", ""), ".", "")
	words := strings.Fields(rawText)

	numOfAppearances := make(map[string]int)
	for _, w := range words {
		numOfAppearances[w]++
	}
	for k, v := range numOfAppearances {
		fmt.Println(k, v)
	}
}
```
