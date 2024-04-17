# Advent of Code 2015 - Day 15

import std/[strscans,strutils,sequtils]
import ../utils/common

type
  Ingredient = tuple
    name: string
    prop: array[4, int]
    calories: int

  Data = seq[Ingredient]


func parseIngredient(line: string): Ingredient =
  assert line.scanf("$+: capacity $i, durability $i, flavor $i, texture $i, calories $i",
    result.name, result.prop[0], result.prop[1], result.prop[2], result.prop[3], result.calories)


proc parseData: Data =
  readInput().strip.splitLines.map(parseIngredient)


func findNonzero(comb: seq[int]): int {.inline.} =
  for i, val in comb:
      if val != 0:
        return i


iterator weakCombinations(n, k: int): seq[int] =
  var comb = newSeq[int](k)
  comb[0] = n
  yield comb
  var j = 0
  while j < k-1:
    let v = comb[j]
    comb[j] = 0
    comb[0] = v - 1
    comb[j + 1].inc
    yield comb
    j = comb.findNonzero


func calcScore(data: Data, sizes: seq[int]): int =
  result = 1
  for i in 0..3:
    var total = 0
    for j, item in data:
      total += item.prop[i] * sizes[j]
    result = result * max(total, 0)


func calories(data: Data, sizes: seq[int]): int =
  for j, item in data:
    result += item.calories * sizes[j]


func highestScore(data: Data, total: int, calories = 0): int =
  for sizes in total.weakCombinations(data.len):
    if calories == 0 or data.calories(sizes) == calories:
      let score = data.calcScore(sizes)
      if score > result:
        result = score


let data = parseData()

benchmark:
  echo data.highestScore(100)
  echo data.highestScore(100, calories=500)
