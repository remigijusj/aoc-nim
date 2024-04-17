# Advent of Code 2022 - Day 20

import std/[strutils,sequtils,algorithm]
from math import euclMod
import ../utils/common

type Data = seq[int]

proc parseData: Data =
  readInput().strip.splitLines.map(parseInt)


func mixing(data: Data, num = 1): Data =
  result = data
  var index = toSeq(0..data.high)

  for _ in 1..num:
    for s in 0..data.high:
      let i = index.find(s)
      let n = result[i]
      let j = 1 + euclMod(i + n - 1, data.len-1)
      let slice = if i < j: i..j else: j..i
      let shift = if i < j: 1 else: -1

      result.rotateLeft(slice, shift)
      index.rotateLeft(slice, shift)


func coordinates(data: Data): int =
  let zero = data.find(0)
  result = [1000, 2000, 3000].mapIt(data[euclMod(zero + it, data.len)]).sum


let data = parseData()

benchmark:
  echo data.mixing.coordinates
  echo data.mapIt(it * 811589153).mixing(10).coordinates
