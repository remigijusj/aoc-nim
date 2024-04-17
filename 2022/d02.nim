# Advent of Code 2022 - Day 2

import std/[strutils,sequtils]
import ../utils/common

type
  Round = tuple[a, x: int]

  Data = seq[Round]


proc parseRound(line: string): Round =
  (line[0].ord - 'A'.ord, line[2].ord - 'X'.ord)


proc parseData: Data =
  readInput().strip.splitLines.map(parseRound)


func score(choose, outcome: int): int =
  choose + 1 + outcome * 3


let data = parseData()

benchmark:
  echo data.mapIt(score(it.x, (it.x - it.a + 4) mod 3)).sum
  echo data.mapIt(score((it.a + it.x + 2) mod 3, it.x)).sum
