# Advent of Code 2022 - Day 25

import std/[strutils,sequtils]

const digits = "=-012"

type Data = seq[int]


func parseSnafu(line: string): int =
  line.mapIt(digits.find(it)-2).foldl(a * 5 + b)


proc parseData: Data =
  readAll(stdin).strip.splitLines.map(parseSnafu)


func toSnafu(n: int): string =
  var n = n
  var d = 0
  while n != 0:
    d = n mod 5
    n = n div 5
    if d > 2:
      d -= 5
      n += 1
    result.insert $digits[d+2]


let data = parseData()

echo data.foldl(a + b).toSnafu
