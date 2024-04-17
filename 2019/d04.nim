# Advent of Code 2019 - Day 4

import std/[strscans, sequtils]
import ../utils/common

type Data = Slice[int]


proc parseData: Data =
  discard readInput().scanf("$i-$i", result.a, result.b)


proc hasDrop(code: string): bool =
  for i in 1..<code.len:
    if code[i] < code[i-1]: return true


proc hasPair(code: string, strict = false): bool =
  var cons = 1
  for i in 1..<code.len:
    if code[i] == code[i-1]:
      cons.inc
    if code[i] != code[i-1] or i == code.len-1:
      if cons == 2 or (cons > 2 and not strict): return true
      cons = 1


proc isGood(num: int, strict = false): bool =
  let code = $(num)
  result = not code.hasDrop and code.hasPair(strict)


let data = parseData()

benchmark:
  echo data.countIt(it.isGood)
  echo data.countIt(it.isGood(true))
