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

* そこまで目新しいものはなかった

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

# Lesson20 チャレンジ:ライフのスライス

## 結論

* ライフゲーム！

## メモ

* やっぱり↓はわかりにくい。。
```go
type Universe [][]bool

func NewUniverse() Universe {
	u := make(Universe, height)   // Universe型 x height ？？
	for i := range u {
		u[i] = make([]bool, width)
	}
	return u
}
```

```go:lifegame.go
// ポインタ使ってしまうあたりにcぽさが出てしまった
package main

import (
	"fmt"
	"math/rand"
	"time"
)

const (
	width          = 80
	height         = 15
	seedPercentage = 25
)

type Universe [][]bool

func NewUniverse() Universe {
	u := make(Universe, height)
	for i := range u {
		u[i] = make([]bool, width)
	}
	return u
}

func (u Universe) writeBorder(c int) {
	for w := 0; w < width; w++ {
		fmt.Printf("%c", c)
	}
	fmt.Printf("\n")
}

func (u Universe) Show() {
	u.writeBorder('=')
	for h := 0; h < height; h++ {
		for w := 0; w < width; w++ {
			if u[h][w] {
				fmt.Printf("#")
			} else {
				fmt.Printf(" ")
			}
		}
		fmt.Printf("\n")
	}
	u.writeBorder('-')
}

func (u Universe) String() string {
	var b byte
	buf := make([]byte, 0, (width+1)*height)
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			b = ' '
			if u.Alive(x, y) {
				b = '*'
			}
			buf = append(buf, b)
		}
		buf = append(buf, '\n')
	}
	return string(buf)
}

func (u Universe) Seed() {
	lives := height * width * seedPercentage / 100
	last := height * width
	for i := 0; i < lives; i++ {
		n := rand.Intn(last)
		u[n/width][n%width] = true
	}
}

func (u Universe) Alive(x, y int) bool {
	x = (x + width) % width
	y = (y + height) % height
	return u[y][x]
}

func (u Universe) Neighbors(x, y int) int {
	ret := 0
	type Pair struct {
		xpos int
		ypos int
	}
	targets := []Pair{
		Pair{xpos: x - 1, ypos: y - 1},
		Pair{xpos: x, ypos: y - 1},
		Pair{xpos: x + 1, ypos: y - 1},
		Pair{xpos: x - 1, ypos: y},
		Pair{xpos: x + 1, ypos: y},
		Pair{xpos: x - 1, ypos: y + 1},
		Pair{xpos: x, ypos: y + 1},
		Pair{xpos: x + 1, ypos: y + 1},
	}
	for _, t := range targets {
		if u.Alive(t.xpos, t.ypos) {
			ret++
		}
	}
	return ret
}

func (u Universe) Next(x, y int) bool {
	alive := u.Alive(x, y)
	switch u.Neighbors(x, y) {
	case 2:
		if alive {
			return true
		} else {
			return false
		}
	case 3:
		return true
	default:
		return false
	}
}

func Step(a, b Universe) {
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			if a.Next(x, y) {
				b[y][x] = true
			} else {
				b[y][x] = false
			}
		}
	}
}

func main() {
	u := NewUniverse()
	u2 := NewUniverse()
	u.Seed()

	var a, b *Universe
	a = &u
	b = &u2
	for {
		fmt.Print("\x0c", (*a).String())
		time.Sleep(200 * time.Millisecond)
		Step(*a, *b)
		a, b = b, a
	}

}
```

# Lesson21 構造体

## 結論

* 

## メモ

```go:list21-10_json-tags.go
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

func main() {
	type location struct {
		Lat  float64 `json:"latitude"`
		Long float64 `json:"longitude"`
	}

	curiosity := location{-4.5895, 137.4417}
	bytes, err := json.Marshal(curiosity)
	exitOnError(err)

	fmt.Println(string(bytes))
}

func exitOnError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
```

# Lesson22 Goにはクラスがないけれど

## 結論

* 構造体にメソッドを「結びつける」
* 「ほぼOOPな事ができる」とはあるし、それはわかる
* じゃぁ何が違うの・・・？の理解はまだもう少し

## メモ

``` go:list22-2_coordinate.go
package main

import "fmt"

type coordinate struct {
	d, m, s float64
	h       rune
}

func (c coordinate) decimal() float64 {
	sign := 1.0
	switch c.h {
	case 'S', 'W', 's', 'w':
		sign = -1
	}
	return sign * (c.d + c.m/60 + c.s/3600)
}

func main() {
	lat := coordinate{4, 35, 22.2, 'S'}
	long := coordinate{137, 26, 30.12, 'E'}
	fmt.Println(lat.decimal(), long.decimal())
}
```

# Lesson23 組み立てと転送

## 結論

* 転送？
   * 内部の構造体のメソッドを呼ぶような事を「転送」と呼んでいる -> list23-3
* 埋め込み
   * 構造体にフィールド名無しに型名を指定する
   * 埋め込んだメソッドはコンパイル時に解決するぽい
      * (当然、)メソッド名が重複するなど解決仕切れなければコンパイルエラーになる
   * 埋め込みはフィールドも範囲

## メモ

* コンポジションとは、大きな構造を小さな構造に分解して組み合わせる技法

```go:list23-3_average.go
type temperature struct {
   high, low celsius
}

func (t temperature) average() float64 {
   // ~~~~
   return 0.0
}

type report struct {
   temp temperature
}

func (r report) average() float64{
   return r.temp.average() // これを「転送」と呼んでいる
}

type celsius float64
```

```go:list23-4_embed.go
package main

import "fmt"

type temperature struct {
	high, low float64
}

func (t temperature) average() float64 {
	return (t.high + t.low) / 2
}

type location struct {
	lat, long float64
}

type report struct {
	sol int
	temperature // "埋め込み" := フィールド名無しに型を指定する
	location
}

func main() {
	report := report{
		sol:         15,
		location:    location{-4.5895, 137.4417},
		temperature: temperature{high: -1.0, low: -78.0},
	}
	fmt.Printf("平均 %v℃\n", report.average())
}
```

# Lesson24 インターフェース

(だんだんわかってないところに入ってきた)

## 結論

* まだわかってる範囲だった

## メモ

* インターフェース型は「型が何を行えるか？に注目」したもの

# Lesson26 ポインタ

## 結論

* `map`は実はポインタらしい 
   * `func f(m *map[int]string)` みたいなのは余計な定義
* スライスの実現 := {配列へのポインタ, 長さ, 容量}
   * `type Slice struct{ p *[]array, len int, depth int}`
   * スライスそのものを書き換える必要がある場合のみ、スライスのポインタが意味を成してくる
   * ただしスライスは**それを変更するよりコピーを生成して編集する**方がよさそう

## メモ

* `ptr++`みたいな演算はできない

```go:list26-13_method.go
package main

import "fmt"

type X struct {
	age int
}

func (x X) f() {
	x.age++
}

func (x *X) g() {
	x.age++
}

func main() {
	x := X{age: 10}
	fmt.Printf("%+v\n", x) //=> 10
	x.f()
	fmt.Printf("%+v\n", x) //=> 10
	x.g()
	fmt.Printf("%+v\n", x) //=> 11
}
```

```go:list26-20_interface.go
package main

import (
	"fmt"
	"strings"
)

type talker interface {
	talk() string
}

func shout(t talker) {
	louder := strings.ToUpper(t.talk())
	fmt.Println(louder)
}

type laser int

func (l *laser) talk() string {
	return "laser pointer"
}

//func (l laser) talk() string {
//	return "laser instance"
//}

func main() {
	per := laser(2)
	//shout(per)
	shout(&per)
}
 
```
