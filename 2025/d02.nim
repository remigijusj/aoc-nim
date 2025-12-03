# Advent of Code 2025 - Day 2

import std/[strutils,sequtils,math,re]
import ../utils/common

type
  Range = Slice[int]

  Data = seq[Range]


func parseRange(line: string): Range =
  let pts = line.split("-")
  result = pts[0].parseInt .. pts[1].parseInt


proc parseData: Data =
  readInput().strip.split(",").map(parseRange)


func digits(n: int): int = n.float.log10.floor.int + 1


func invalid1(n: int): bool =
  let digits = n.digits
  if digits mod 2 == 0:
    let split = 10 ^ (digits div 2)
    let (hi, lo) = divMod(n, split)
    return hi == lo


func invalid2(n: int): bool =
  let digits = n.digits
  var split = 1
  for s in 1..(digits div 2):
    split *= 10
    if digits mod s != 0:
      continue

    var (hi, lo) = divMod(n, split)
    block inner:
      while hi > 0:
        let (hi2, lo2) = divMod(hi, split)
        if lo2 != lo:
          break inner
        hi = hi2
      return true


proc filteredSum(data: Data, cond: proc(n: int): bool): int =
  for rg in data:
    for n in rg:
      if cond(n):
        result += n


let data = parseData()

benchmark:
  echo data.filteredSum(invalid1)
  echo data.filteredSum(invalid2)
