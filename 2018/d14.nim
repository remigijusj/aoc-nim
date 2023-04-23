# Advent of Code 2018 - Day 14

import std/[strutils]

type Data = string

proc parseData: Data = readAll(stdin).strip


func runRecipes1(data: Data): string =
  let datai = data.parseInt

  var list = "37"
  var (a, b) = (0, 1)
  while true:
    let s = list[a].ord - '0'.ord
    let t = list[b].ord - '0'.ord
    let sum = s + t
    list.add($sum)
    a = (a + s + 1) mod list.len
    b = (b + t + 1) mod list.len

    if list.len >= datai + 10:
      return list[datai..<datai+10]


func runRecipes2(data: Data): string =
  var list = "37"
  var (a, b) = (0, 1)
  while true:
    let s = list[a].ord - '0'.ord
    let t = list[b].ord - '0'.ord
    let sum = s + t
    list.add($sum)
    a = (a + s + 1) mod list.len
    b = (b + t + 1) mod list.len

    let start = list.len - data.len
    if start >= 1:
      if list.continuesWith(data, start-1): return $(start-1)
      if list.continuesWith(data, start): return $start


let data = parseData()

echo runRecipes1(data)
echo runRecipes2(data)
