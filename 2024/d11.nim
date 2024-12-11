# Advent of Code 2024 - Day 11

import std/[strutils,sequtils,tables]
from math import divMod,log10,floor,`^`
import ../utils/common

type Data = seq[int]


proc parseData: Data =
  readInput().strip.splitWhitespace.map(parseInt)


iterator blinkOnce(stone: int): int =
  if stone == 0:
    yield 1
  else:
    let size = floor(log10(stone.float)).int + 1
    if size mod 2 == 0:
      let z = 10 ^ (size div 2)
      let (a, b) = divMod(stone, z)
      yield a
      yield b
    else:
      yield stone * 2024


func blink(data: Data, times: int): CountTable[int] =
  result = data.toCountTable
  var counts: CountTable[int]
  for _ in 1..times:
    swap(counts, result)
    result.clear
    for this, cnt in counts:
      for next in this.blinkOnce:
        result[next] = result.getOrDefault(next) + cnt


let data = parseData()

benchmark:
  echo data.blink(25).values.toSeq.sum
  echo data.blink(75).values.toSeq.sum
