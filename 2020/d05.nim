# Advent of code 2020 - Day 5

import std/[strutils, sequtils, algorithm]
import ../utils/common

type Data = seq[int]


proc decodeBinary(code, lo, hi: string): int =
  let code = code.multiReplace [(lo,"0"), (hi,"1")]
  code.parseBinInt


proc parseSeat(line: string): int =
  let row = line[0..6].decodeBinary("F","B")
  let col = line[7..9].decodeBinary("L","R")
  return row * 8 + col


proc parseData: Data =
  readInput().strip.splitLines.map(parseSeat)


proc findGap(list: Data): int =
  let list = list.sorted
  let first = list[0]
  for i, seat in list:
    if seat != first + i:
      return first + i


let data = parseData()

benchmark:
  echo data.max
  echo data.findGap
