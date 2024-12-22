# Advent of Code 2024 - Day 22

import std/[strutils,sequtils]
import ../utils/common
import bitty

type
  Data = seq[int]

const
  cut = 0xFFF_FFF # 16777216-1


proc parseData: Data =
  readInput().strip.splitLines.map(parseInt)


func nextPN(n: int): int {.inline.} =
  result = n
  result = ((result shl  6) xor result) and cut
  result = ((result shr  5) xor result) and cut
  result = ((result shl 11) xor result) and cut


func mutate(seed, limit: int): int =
  result = seed
  for _ in 1..limit:
    result = result.nextPN


func index(d: seq[int]): int {.inline.} =
  result += d[^4] + 9
  result *= 19
  result += d[^3] + 9
  result *= 19
  result += d[^2] + 9
  result *= 19
  result += d[^1] + 9


proc maxBananas(data: Data): int =
  var total = newSeq[int](19 * 19 * 19 * 19)
  var seen = newBitArray(19 * 19 * 19 * 19)
  var delta = newSeqOfCap[int](2000)

  for num in data:
    delta.setLen(0)
    seen.clear
    var num = num
    var prev = num mod 10

    for i in 1..2000:
      num = num.nextPN
      let this = num mod 10
      delta.add(this - prev)
      if i >= 4:
        let i = delta.index
        if not seen[i]:
          total[i] += this
          seen[i] = true
      prev = this

  result = total.max


let data = parseData()

benchmark:
  echo data.mapIt(it.mutate(2000)).sum
  echo data.maxBananas
