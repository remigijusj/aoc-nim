# Advent of code 2020 - Day 2

import std/[strscans, strutils, sequtils]
import ../utils/common

type
  Item = object
    a, b: int
    c: char
    pass: string

  Data = seq[Item]


proc parseItem(line: string): Item =
  discard scanf(line, "$i-$i $c: $+", result.a, result.b, result.c, result.pass)


proc parseData: Data =
  readInput().strip.splitLines.map(parseItem)


proc validCount(it: Item): bool =
  it.pass.count(it.c).in (it.a .. it.b)


proc validPositions(it: Item): bool =
  it.pass[it.a - 1] == it.c xor it.pass[it.b - 1] == it.c


let data = parseData()

benchmark:
  echo data.countIt(it.validCount)
  echo data.countIt(it.validPositions)
